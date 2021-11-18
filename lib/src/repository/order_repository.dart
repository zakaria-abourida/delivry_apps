import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/courier_order.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/restaurant.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../services/crashlytics_service.dart';

Future<Stream<Order>> getOrders() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Order.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<Order>> getOrder(orderId) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;deliveryAddress;payment';
    print(url);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) {
        print(Order.fromJSON(data).orderStatus.id);
        return Order.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<Order>> getRecentOrders() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
  
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Order.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<OrderStatus>> getOrderStatus({bool isCourier = false}) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    String url;
    if (isCourier)
      url = '${COURIER_API_URL}order_coursier_statuses?$_apiToken';
    else
      url =
          '${GlobalConfiguration().getValue('api_base_url')}order_statuses?$_apiToken';
    log(url);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      log(data.toString());
      return OrderStatus.fromJSON(data);
    });
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Order> addOrder(Order order, Payment payment, Coupon coupon) async {
  try {
    User _user = userRepo.currentUser.value;

    if (_user.apiToken == null) {
      return new Order();
    }

    CreditCard _creditCard = await userRepo.getCreditCard();

    order.user = _user;
    order.payment = payment;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('comment')) order.comment = prefs.get('comment');

    print(order.comment);
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders?$_apiToken';
    log(url);

    final client = new http.Client();
    Map params = order.toMap();
    params.addAll(_creditCard.toMap());
    params.addAll(coupon.getCode());

    log("ORDER PARAMS" + params.toString());

    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(params),
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body);
      return Order.fromJSON(json.decode(response.body)['data']);
    } else {
      throw new Exception(response.body);
    }
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Order> cancelOrder(Order order) async {
  // print(order.toMap());
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.cancelMap()),
  );
  if (response.statusCode == 200) {
    return Order.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
}

Future<Stream<Address>> getDeliveryAddress(deliveryAddressId,
    {bool isCourier = false}) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    String url;
    if (isCourier)
      url =
          '${COURIER_API_URL}delivery_addresses/$deliveryAddressId?${_apiToken}';
    else
      url =
          '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/$deliveryAddressId?${_apiToken}';

    log(url);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) {
        log(data.toString());
        return Address.fromJSON(data);
      });
    else
      throw Exception(streamedRest.request.toString());
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<Restaurant>> getRestaurant(restaurantId) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}restaurants/$restaurantId?${_apiToken}';
    print(url);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) {
        return Restaurant.fromJSON(data);
      });
    else
      Exception(streamedRest.request);
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Address> getDriverLiveLocation(driverId) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Address();
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}driver_location/live?${_apiToken}driver_id=$driverId';
    print(url);

    final client = new http.Client();
    //final streamedRest = await client.send(http.Request('post', Uri.parse(url)));

    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (response.statusCode == 200) {
      return Address.fromJSONForDriver(json.decode(response.body)['data']);
    } else
      throw Exception(response.body);
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<OrderStatus>> getLatestOrderStatus(orderId) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId/latest_status?${_apiToken}';
    print(url);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) {
        return OrderStatus.fromJSON(data);
      });
    else
      throw Exception(streamedRest.request);
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<User>> getDriverInfo(driverId, {bool isCourier = false}) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${isCourier ? COURIER_API_URL : GlobalConfiguration().getValue('api_base_url')}drivers?$_apiToken&search=user_id:$driverId&searchFields=user_id:=&with=user';
    log(url);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) {
        debugPrint(data.toString());
        return User.driverFromJSON(data[0]);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
  }
}

Future<CourierOrder> addCourierOrder(CourierOrder courierOrder) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new CourierOrder();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url = '${COURIER_API_URL}order_coursiers?${_apiToken}';
    log(url);
    log(courierOrder.toMap().toString());

    final client = new http.Client();
    final response = await client.post(url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(courierOrder.toMap()));
    log(response.body);
    if (response.statusCode == 200) {
      return CourierOrder.fromMap(json.decode(response.body)['data']);
    } else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<CourierOrder> getCourierOrder(orderId) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new CourierOrder();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${COURIER_API_URL}order_coursiers/$orderId?${_apiToken}';
    print(url);

    final client = new http.Client();

    final response = await client.get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return CourierOrder.fromMap(json.decode(response.body)['data']);
    } else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<CourierOrder>> getCourierOrders() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${COURIER_API_URL}order_coursiers?${_apiToken}with=user;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';
    log(url);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return CourierOrder.fromMap(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}
