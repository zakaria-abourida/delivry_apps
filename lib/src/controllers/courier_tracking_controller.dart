import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../helpers/helper.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';
import '../models/courier_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/route_argument.dart';
import '../models/user.dart';
import '../repository/order_repository.dart';

class CourierTrackingController extends ControllerMVC {
  // For holding Co-ordinates as LatLng
  final List<LatLng> polyPoints = [];
//For holding instance of Polyline
  final Set<Polyline> polyLines = {};
  CourierOrder order;
  List<OrderStatus> orderStatus = <OrderStatus>[];
  OrderStatus currentOrderStatus;
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();
  List<Marker> allMarkers = <Marker>[];
  Address collectAddress;
  Address deliveryAddress;
  Address driverAddress;
  MarkerId driverMarkerId = MarkerId('webili_driver');
  Timer orderStatusTimer;
  Timer driverLocationTimer;
  GoogleMapController mapController;
  Completer<GoogleMapController> controller = Completer();
  bool isDriverArrived = false;
  User driverInfo;
  double distance;

  CourierTrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void latestOrderStatusTimer() {
    orderStatusTimer = Timer.periodic(
        Duration(seconds: 30), (Timer t) => listenForOrder(order));
  }

  void driverLocationLiveTimer() {
    driverLocationTimer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => listenFoDriverLiveLocation());
  }

  Future<void> addAddressMarker(double lat, double long,
      {bool isCollectAddress = false}) async {
    mapController = await controller.future;

    await Helper.getMyPositionMarker(lat, long,
            path: isCollectAddress
                ? 'assets/img/icons-localisation-2-.png'
                : 'assets/img/icons-localisation-2-.png',
            markerId: MarkerId(Random().nextInt(1000).toString()))
        .then((marker) => allMarkers.add(marker));
  }

  Future<void> addDriverMarker(double lat, double long) async {
    mapController = await controller.future;
    await Helper.getMyPositionMarker(lat, long,
            path: 'assets/img/moto.png', markerId: driverMarkerId)
        .then((marker) {
      allMarkers.removeWhere((item) => item.markerId == driverMarkerId);
      allMarkers.add(marker);

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        Helper.getCPosition(lat, long),
      ));
    });
  }

  void listenForOrder(CourierOrder courierOrder) async {
    order = courierOrder;
    await getCourierOrder(order.id).then((_order) {
      if (_order != null) {
        order = _order;
        if (orderStatus.length == 0) {
          listenForOrderStatus();
        } else {
          setOrderStatus();
        }
        if (collectAddress == null)
          listenForAddress(order.collectAddressId.toString(),
              isCollectAddress: true);
        if (deliveryAddress == null)
          listenForAddress(order.deliveryAddressId.toString());

        latestOrderStatusTimer();
      }
    }).catchError((onError) {});
  }

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus(isCourier: true);
    stream.listen(
        (OrderStatus _orderStatus) {
          orderStatus.add(_orderStatus);
        },
        onError: (a) {},
        onDone: () {
          setOrderStatus();
        });
  }

  Future<void> refreshOrder(String orderId) async {
    order = new CourierOrder();
    listenForOrder(order);
  }

  void doCancelOrder() {
    /* cancelOrder(this.order).then((value) {
      setState(() {
        this.order.active = false;
      });
    }).catchError((e) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e),
      ));
    }).whenComplete(() {
      orderStatus = [];
      listenForOrderStatus();
      vdialog.pop(context,
          S.of(context).orderThisorderidHasBeenCanceled(this.order.id));
    }); */
  }

  bool canCancelOrder(Order order) {
    return order.active == true && currentOrderStatus.id == 1;
  }

  listenForAddress(String addressId, {bool isCollectAddress = false}) async {
    final Stream<Address> stream =
        await getDeliveryAddress(addressId, isCourier: true);
    stream.listen((Address address) async {
      if (address != null) {
        if (isCollectAddress) {
          collectAddress = address;
          await addAddressMarker(
              collectAddress.latitude, collectAddress.longitude,
              isCollectAddress: true);
        } else {
          deliveryAddress = address;
          await addAddressMarker(
              deliveryAddress.latitude, deliveryAddress.longitude);
        }
        setState(() {});
      }
    }, onError: (a) {}, onDone: () {});
  }

  listenFoDriverLiveLocation() async {
    final driverAdd = await getDriverLiveLocation(order.driverId);
    if (driverAdd != null &&
        driverAdd != driverAddress &&
        driverAdd.latitude != null &&
        driverAdd.longitude != null) {
      driverAddress = driverAdd;
      await addDriverMarker(driverAdd.latitude, driverAdd.longitude);
      polyPoints.add(LatLng(driverAdd.latitude, driverAdd.longitude));
      distance = calculateDistanceBetweenDriverAndClient();
      debugPrint("calculateDistanceBetweenDriverAndClient ==> $distance");
      if (distance < 100) {
        debugPrint(
            "Client Address ==> ${deliveryAddress.latitude},${deliveryAddress.longitude}");
        debugPrint(
            "Driver Address ==> ${driverAdd.latitude},${driverAdd.longitude}");
        isDriverArrived = true;
      }

      setState(() {});
    }
  }

  listenFoLatestOrderStatus() async {
    final Stream<OrderStatus> stream = await getLatestOrderStatus(order.id);
    stream.listen((OrderStatus _status) async {
      if (_status != null) {
        currentOrderStatus = _status;
        if (currentOrderStatus.id == "6") isDriverArrived = true;
        setState(() {});
      }
    }, onError: (a) {}, onDone: () {});
  }

  listenForDriverInfo() async {
    final Stream<User> stream =
        await getDriverInfo(order.driverId, isCourier: true);
    stream.listen((User _user) async {
      if (_user != null) {
        debugPrint("RATING " + _user.rating.toString());
        driverInfo = _user;
        setState(() {});
      }
    }, onError: (a) {}, onDone: () {});
  }

  double calculateDistanceBetweenDriverAndClient() {
    return Geolocator.distanceBetween(
        driverAddress.latitude,
        driverAddress.longitude,
        deliveryAddress.latitude,
        deliveryAddress.longitude);
  }

  setPolyLines() {
    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline"),
        color: Constants.primaryColor,
        points: polyPoints,
        width: 5);
    polyLines.add(polyline);
  }

  void callDriver() => Helper.phoneLaunchUri(driverInfo.phone);

  void setOrderStatus() {
    currentOrderStatus = orderStatus.firstWhere(
        (element) => element.id == order.orderStatusId.toString(),
        orElse: () => null);
    setState(() {});

    if (currentOrderStatus.id == "4" || currentOrderStatus.id == "5") {
      if (order.driverId != null && driverInfo == null) listenForDriverInfo();
      driverLocationLiveTimer();
    }
    if (currentOrderStatus.id == "6") isDriverArrived = true;
    if (currentOrderStatus.id == "7") navigateToReview();
    if (collectAddress == null)
      listenForAddress(order.collectAddressId.toString(),
          isCollectAddress: true);
    if (deliveryAddress == null)
      listenForAddress(order.deliveryAddressId.toString());
  }

  String calculateTimeByDistance() {
    print('distance ===>' + distance.toString());
    var time = ((((distance) + distance * 0.6) / 30) / 60) + 10;
    return time.ceil().toString();
  }

  void navigateToReview() {
    disposeAll();
    Navigator.of(context).pushReplacementNamed('/CourierReviews',
        arguments: RouteArgument(id: order.id.toString(), param: driverInfo));
  }

  void disposeAll() {
    mapController.dispose();
  }
}
