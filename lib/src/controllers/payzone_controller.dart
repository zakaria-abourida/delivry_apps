import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/zoning_fields.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/address.dart';
import '../models/courier_order.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class PayZoneController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  WebViewController webView;
  String url = "";
  double progress = 0;
  Address deliveryAddress;
  bool isCourierOrder = false;
  CourierOrder courierOrder;
  ZoningFields zoningFields;
  String restaurantId;

  PayZoneController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    final String _userId = 'user_id=${userRepo.currentUser.value.id}';

    if (isCourierOrder) {
      final String _deliveryAddress =
          'delivery_address_id=${courierOrder?.deliveryAddressId}';
      final String _collectAddress =
          'collect_address_id=${courierOrder?.collectAddressId}';
      final String _deliveryFees = 'delivery_fees=${courierOrder?.deliveryFee}';
      final String _comment = 'comment=${courierOrder?.comment}';
      final String _amount = 'amount=${courierOrder?.amount}';
      final String _price = 'price=${courierOrder?.price}';
      final String _orderStatusId =
          'order_status_id=${courierOrder?.orderStatusId}';
      final String _distance = 'distance=${courierOrder?.distance}';
      final String _hour = 'hour=${courierOrder?.hour}';
      final String _duration = 'duration=${courierOrder?.duration}';
      final String _active = 'active=${courierOrder?.active}';

      url =
          'https://admin.webiliapp.com/payments/orderCoursierPayzone?$_apiToken&$_userId&$_deliveryAddress&$_collectAddress&$_deliveryFees&$_comment&$_amount&$_price&$_orderStatusId&$_distance&$_hour&$_duration&$_active';
    } else {
      final String _deliveryAddress =
          'delivery_address_id=${settingRepo.deliveryAddress.value?.id}';
      final String _couponCode = 'coupon_code=${settingRepo.coupon?.code}';
      final String _restaurantId = 'restaurant_id=$restaurantId';

      final String _restaurantAddressId =
          'restaurant_address_id=${zoningFields.restaurantAddressId}';
      final String _deliveryAmount =
          'delivery_amount=${zoningFields.deliveryAmount}';
      final String _distance = 'distance=${zoningFields.distance}';
      final String _time = 'time=${zoningFields.time}';

      url =
          'https://admin.webiliapp.com/payments/payzone?$_apiToken&$_userId&$_deliveryAddress&$_couponCode&$_restaurantId&$_restaurantAddressId&$_deliveryAmount&$_distance&$_time';
    }
    log(url);

    // ?$_apiToken&$_couponCode';
    print(url);
    setState(() {});
    super.initState();
  }

  Future<bool> checkTransation() async {
    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    url = 'https://admin.webiliapp.com/orders/checkTransaction?$_apiToken';

    final client = new http.Client();
    var response = null;
    await client
        .get(
          url,
        )
        .then((value) => response = value);
    if (response?.success == false)
      return false;
    else
      return true;
  }
}
