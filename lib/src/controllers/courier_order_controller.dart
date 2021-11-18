import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/setting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../helpers/maps_util.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';
import '../models/courier_order.dart';
import '../models/distance_matrix.dart';
import '../models/payment.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../pages/payzone_payment.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class CourierOrderController extends ControllerMVC {
  TextEditingController commentInputController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();
  PaymentMethodList list;
  DistanceMatrix distanceMatrix;
  List<String> deliveryTimeList;
  String deliveryTime;
  Address collectAddress;
  Address deliveryAddress;
  int selectedPaymentMethod;
  bool loading = false;
  bool isCourierServiceOpen = false;

  CourierOrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    deliveryTimeList = Helper.courierAvailabilityTimes();
    deliveryTime = deliveryTimeList.first;
  }

  Future<Setting> listenForSetting() async {
    return await settingRepo.getSettings();
  }

  bool checkCourierAvailability(
      String coursierStartTime, String coursierEndTime) {
    DateTime currentDate = DateTime.now();

    double _starTime = double.parse(coursierStartTime.replaceAll(':', '.'));
    double _endTime = double.parse(coursierEndTime.replaceAll(':', '.'));
    double _currentTime = double.parse(
        currentDate.hour.toString() + "." + currentDate.minute.toString());

    return (_currentTime >= _starTime && _currentTime <= _endTime);
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
    print(this.deliveryAddress.id);
  }

  Future<void> checkOrder() async {
    final _courierOrder = validateCourierOrder();
    if (_courierOrder != null) {
      if (selectedPaymentMethod == 1) {
        final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PayZonePaymentWidget(
                      routeArgument:
                          RouteArgument(id: 'courier', param: _courierOrder),
                    ))) as bool;
        if (result != null && result) {
          addOrder(_courierOrder);
        }
      } else {
        addOrder(_courierOrder);
      }
    }
  }

  Future<void> addOrder(CourierOrder _courierOrder) async {
    setState(() => loading = true);
    await orderRepo.addCourierOrder(_courierOrder).then((courierOrder) {
      log(courierOrder.toString());
      if (courierOrder != null)
        Navigator.of(context).pushReplacementNamed('/CourierOrderSuccess',
            arguments: RouteArgument(param: courierOrder));
    }).catchError((onError) {
      log(onError.toString());
    }).whenComplete(() => setState(() => loading = false));
  }

  void onChangedDeliveryTime(String value) =>
      setState(() => deliveryTime = value);

  void onChangedSelectedPayment(int value) =>
      setState(() => selectedPaymentMethod = value);

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  void toggleDelivery({selected = false}) {
    list.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      if (selected)
        getDeliveryMethod().selected = selected;
      else
        getDeliveryMethod().selected = !getDeliveryMethod().selected;
    });
  }

  void togglePickUp() {
    list.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
    });
  }

  PaymentMethod getSelectedMethod() {
    return list.pickupList.firstWhere((element) => element.selected);
  }

  Future<void> calculateDistance() async {
    await MapsUtil()
        .getDistanceMatrix(
      LatLng(collectAddress.latitude, collectAddress.longitude),
      LatLng(deliveryAddress.latitude, deliveryAddress.longitude),
    )
        .then((value) {
      if (value != null) {
        log(value.distance.toJson().toString());
        distanceMatrix = value;
      }
    }).catchError((onError) => debugPrint('$onError'));
  }

  CourierOrder validateCourierOrder() {
    if (collectAddress == null) {
      vdialog.pop(context, "Veuillez sélectionner l'adresse de collecte");
      return null;
    }
    if (deliveryAddress == null) {
      vdialog.pop(context, "Veuillez sélectionner l'adresse de livraison");
      return null;
    }
    if (Helper.simpleConvertDistanceToKm(distanceMatrix.distance.value) <
            double.parse(settingRepo.setting.value.coursierDistanceMin) ||
        Helper.simpleConvertDistanceToKm(distanceMatrix.distance.value) >
            double.parse(settingRepo.setting.value.coursierDistanceMax)) {
      vdialog.pop(context,
          "la distance entre l'adresse de collecte et l'adresse de livraison doit être supérieure à ${settingRepo.setting.value.coursierDistanceMin} Km et inférieure ${settingRepo.setting.value.coursierDistanceMax} Km");
      return null;
    }
    if (commentInputController.text.trim() == null ||
        commentInputController.text.trim().isEmpty) {
      vdialog.pop(context, "Veuillez rédiger votre commande");
      return null;
    }
    if (selectedPaymentMethod == null) {
      vdialog.pop(context, "Veuillez sélectionner le mode de paiement");
      return null;
    }
    /*  if (selectedPaymentMethod == 1) {
      vdialog.pop(
          context, "Ce mode de paiement n'est pas disponible pour le moment");
      return null;
    } */
    return new CourierOrder(
        userId: int.parse(userRepo.currentUser.value.id),
        deliveryAddressId: int.parse(deliveryAddress.id),
        collectAddressId: int.parse(collectAddress.id),
        comment: commentInputController.text.trim(),
        hour: deliveryTime.contains('Dès que possible')
            ? null
            : deliveryTime.replaceAll('h', ':').replaceAll(' ', ''),
        orderStatusId: 1,
        distance:
            Helper.simpleConvertDistanceToKm(distanceMatrix.distance.value),
        amount: Helper.calculateCourierFeesByDistance(
            distanceMatrix.distance.value),
        payment: new Payment('Cash on Delivery'));
  }

  void addAddress(Address address, {isCollectAddress = false}) {
    userRepo.addAddress(address, isCourier: true).then((_address) async {
      if (_address != null) {
        isCollectAddress
            ? collectAddress = _address
            : deliveryAddress = _address;
        if (collectAddress != null && deliveryAddress != null) {
          await calculateDistance();
        } else {
          log("collect or delivery address is null");
        }
        setState(() {});
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).new_address_added_successfully),
        ));
      }
    }).catchError((onError) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }
}
