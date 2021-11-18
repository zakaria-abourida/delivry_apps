import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../services/crashlytics_service.dart';

Future<Stream<Cart>> getCart() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().get('api_base_url')}carts?${_apiToken}with=food;food.restaurant;extras&search=user_id:${_user.id}&searchFields=user_id:=';
    log(url);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    log(streamedRest.statusCode.toString());
    if (streamedRest.statusCode == 200) {
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Cart.fromJSON(data);
      });
    } else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<int>> getCartCount() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(0);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().get('api_base_url')}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map(
            (data) => Helper.getIntData(data),
          );
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Cart> addCart(Cart cart, bool reset) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Cart();
    }
    Map<String, dynamic> decodedJSON = {};
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String _resetParam = 'reset=${reset ? 1 : 0}';
    cart.userId = _user.id;
    final String url = 
        '${GlobalConfiguration().get('api_base_url')}carts?$_apiToken&$_resetParam';
    final client = new http.Client();
    log(url);

    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(cart.toMap()),
    );
    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 200) {
      decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;

      return Cart.fromJSON(decodedJSON);

    } else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Cart> updateCart(Cart cart) async {
  try {
    
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Cart();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    cart.userId = _user.id;
    final String url =
        '${GlobalConfiguration().get('api_base_url')}carts/${cart.id}?$_apiToken';
    log('UPDATE CART ===> ' + url);
    final client = new http.Client();
    final response = await client.put(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(cart.toMap()),
    );
    log(response.body);
    if (response.statusCode == 200)
      return Cart.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<bool> removeCart(Cart cart) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return false;
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().get('api_base_url')}carts/${cart.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.delete(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200)
      return Helper.getBoolData(json.decode(response.body));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}
