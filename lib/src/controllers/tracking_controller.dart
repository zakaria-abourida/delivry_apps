import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../models/user.dart';
import '../repository/order_repository.dart';

class TrackingController extends ControllerMVC {
  // For holding Co-ordinates as LatLng
  final List<LatLng> polyPoints = [];
//For holding instance of Polyline
  final Set<Polyline> polyLines = {};
  Order order;
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();
  List<Marker> allMarkers = <Marker>[];
  Address deliveryAddress;
  Address driverAddress;
  Restaurant orderRestaurant;
  MarkerId driverMarkerId = MarkerId('webili_driver');
  Timer orderStatusTimer;
  Timer driverLocationTimer;
  GoogleMapController mapController;
  Completer<GoogleMapController> controller = Completer();
  bool isDriverArrived = false;
  User driverInfo;
  double distance;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void latestOrderStatusTimer() {
    listenFoLatestOrderStatus();
    orderStatusTimer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => listenFoLatestOrderStatus());
  }

  void driverLocationLiveTimer() {
    driverLocationTimer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => listenFoDriverLiveLocation());
  }

  Future<void> addRestaurantMarker(double lat, double long) async {
    mapController = await controller.future;

    await Helper.getMyPositionMarker(lat, long,
            path: 'assets/img/icon-restau.png',
            markerId: MarkerId('webili_restau'))
        .then((marker) {
      allMarkers.add(marker);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        Helper.getCPosition(
            marker.position.latitude, marker.position.longitude),
      ));
    });
  }

  Future<void> addDeliveryAddressMarker(double lat, double long) async {
    mapController = await controller.future;

    await Helper.getMyPositionMarker(lat, long,
            path: 'assets/img/icons-localisation-2-.png',
            markerId: MarkerId('webili_client'))
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

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);

    stream.listen(
        (Order _order) async {
          order = _order;
          setState(() {});
        },
        onError: (a) {},
        onDone: () {
          if (orderStatus.isEmpty) listenForOrderStatus();
          if (orderRestaurant == null)
            listenFoRestaurant(order.foodOrders.first.food.restaurant.id);
          if (deliveryAddress == null)
            listenFoDeliveryAddress(order.deliveryAddressId);
          latestOrderStatusTimer();
        });
  }

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus();
    stream.listen((OrderStatus _orderStatus) {
      orderStatus.add(_orderStatus);
    }, onError: (a) {}, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    this.orderStatus.forEach((OrderStatus _orderStatus) {
      String status = null;
      switch (_orderStatus.status) {
        case "Order Received":
          status = "Commande reçue";
          break;
        case "Preparing":
          status = "En préparation";
          break;
        case "Ready":
          status = "Le livreur est en route pour la récuperer";
          break;
        case "On the Way":
          status = "Le livreur est en route chez vous";
          break;
        case "Delivered":
          status = "Commande livrée";
          break;
        default:
          '';
          break;
      }
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          status ?? "",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: order.orderStatus.id == _orderStatus.id
            ? Text(
                '${DateFormat('HH:mm | yyyy-MM-dd').format(order.dateTime)}',
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            : SizedBox(height: 0),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '${Helper.skipHtml(order.hint)}',
            )),
        isActive: (int.tryParse(order.orderStatus.id)) >=
            (int.tryParse(_orderStatus.id)),
      ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrder() async {
    order = new Order();
    listenForOrder(message: S.of(context).tracking_refreshed_successfuly);
  }

  void doCancelOrder() {
    cancelOrder(this.order).then((value) {
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
    });
  }

  bool canCancelOrder(Order order) {
    return order.active == true && order.orderStatus.id == 1;
  }

  listenFoDeliveryAddress(String deliveryAddressId) async {
    final Stream<Address> stream = await getDeliveryAddress(deliveryAddressId);
    stream.listen((Address address) async {
      if (address != null) {
        order.deliveryAddress = address;
        deliveryAddress = address;

        await addDeliveryAddressMarker(
            deliveryAddress.latitude, deliveryAddress.longitude);

        setState(() {});
      }
    }, onError: (a) {}, onDone: () {});
  }

  listenFoRestaurant(String restaurantId) async {
    final Stream<Restaurant> stream = await getRestaurant(restaurantId);
    stream.listen((Restaurant restau) async {
      if (restau != null) {
        await addRestaurantMarker(
            double.parse(restau.latitude), double.parse(restau.longitude));
        orderRestaurant = restau;

        setState(() {});
      }
    }, onError: (a) {}, onDone: () {});
  }

  listenFoDriverLiveLocation() async {
    final driverAdd = await getDriverLiveLocation(order.driver_id);
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
    stream.listen(
        (OrderStatus _status) async {
          if (_status != null) {
            order.orderStatus = _status;
            setState(() {});
          }
        },
        onError: (a) {},
        onDone: () {
          if (order.orderStatus.id == "3" || order.orderStatus.id == "4") {
            if (driverInfo == null) listenForDriverInfo();
            driverLocationLiveTimer();
          }
          if (order.orderStatus.id == "5") {
            Navigator.of(context).pushReplacementNamed('/Reviews',
                arguments:
                    RouteArgument(id: order.id, heroTag: "restaurant_reviews"));
          }
          if (orderRestaurant == null)
            listenFoRestaurant(order.foodOrders.first.food.restaurant.id);
          if (deliveryAddress == null)
            listenFoDeliveryAddress(order.deliveryAddressId);
        });
  }

  listenForDriverInfo() async {
    final Stream<User> stream = await getDriverInfo(order.driver_id);
    stream.listen((User _user) async {
      debugPrint("RATING " + _user.rating.toString());
      if (_user != null) {
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

  String calculateTimeByDistance() {
    print('distance ===>' + distance.toString());
    var time = ((((distance) + distance * 0.6) / 30) / 60) + 10;
    return time.ceil().toString();
  }
}
