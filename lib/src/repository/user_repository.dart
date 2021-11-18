import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/src/services/crashlytics_service.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<User> login(User user) async {
  try {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}login';

    var data = {
      'email': user.email,
      'password': user.password,
      'device_token': user.deviceToken,
    };

    log(data.toString());

    final response = await http.post(url, body: data
        // headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        // body: json.encode(user.toMap()),
        );
    log(response.body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body)['data'];
      if (responseData != null) {
        currentUser.value = User.fromJSON(responseData);
        setCurrentUser(response.body);
        return currentUser.value;
      }
    }
    throw Exception(response.body);
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<User> providerLogin(provider, token) async {
  try {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
    // final client = new http.Client();
    var data = {
      'email': provider['email'],
      'provider_token': token,
    };
    final response = await http.post(url, body: data
        // headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        // body: json.encode(user.toMap()),
        );

    if (response.statusCode == 200) {
      setCurrentUser(response.body);
      currentUser.value = User.fromJSON(json.decode(response.body)['data']);
    } else {
      throw new Exception(response.body);
    }
    return currentUser.value;
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<User> register(User user) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}register';

    var data = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'phone': user.phone,
    };

    final response = await http.post(
      url,
      // headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: data,
    );

    var myJson = json.decode(response.body);
    bool success = myJson['success'];
    String message = myJson['message'];

    if (success) {
      setCurrentUser(response.body);
      currentUser.value = User.fromJSON(myJson['data']);
      print(CustomTrace(StackTrace.current, message: message).toString());
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(message);
    }
    return currentUser.value;
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
  }
}

Future<User> providerRegister(provider, token, name) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}register';
    var data;
    if (name == "apple") {
      print("'te1");
      if (provider.email == null)
        throw new Exception(
            "Ce compte facebook ne contient pas d'email, Veuillez fournir vos informations manuellement !");

      print("'test1");
      data = {
        'provider_name': name,
        'provider_token': provider.identityToken,
        'name': provider.familyName + " " + provider.givenName,
        'email': provider.email,
        'password': "000000000000"
// 'picture': provider.picture.data.url,
      };
    } else if (name == "apple2") {
      print("te 2");
      data = provider;
    } else {
      if (provider["email"] == null)
        throw new Exception(
            "Ce compte facebook ne contient pas d'email, Veuillez fournir vos informations manuellement !");

      print("'test2");
      data = {
        'provider_name': name,
        'password': "000000000000",
        'provider_token': provider["id"],
        'name': provider["name"],
        'email': provider["email"],
// 'picture': provider.picture.data.url,
      };
    }
    print(data);
    final response = await http.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: data,
    );
    if (response.statusCode == 200) {
      var myJson = json.decode(response.body);
      bool success = myJson['success'];
      String message = myJson['message'];
      if (success) {
        setCurrentUser(response.body);
        currentUser.value = User.fromJSON(myJson['data']);
        return currentUser.value;
      } else
        throw Exception(message);
    } else
      throw Exception(response.body);
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<bool> resetPassword(User user) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}send_reset_link_email';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body);
    }
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return false;
  }
}

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  try {
    if (json.decode(jsonString)['data'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'current_user', json.encode(json.decode(jsonString)['data']));
    }
  } catch (e) {
    log(CustomTrace(StackTrace.current, message: jsonString).toString());
    throw new Exception(e);
  }
}

Future<void> setCreditCard(CreditCard creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<User> getCurrentUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
      currentUser.value =
          User.fromJSON(json.decode(await prefs.get('current_user')));
      currentUser.value.auth = true;
    } else {
      currentUser.value.auth = false;
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentUser.notifyListeners();
    return currentUser.value;
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<CreditCard> getCreditCard() async {
  try {
    CreditCard _creditCard = new CreditCard();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('credit_card')) {
      _creditCard =
          CreditCard.fromJSON(json.decode(await prefs.get('credit_card')));
    }
    return _creditCard;
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<User> update(User user) async {
  try {
    final String _apiToken = 'api_token=${currentUser.value.apiToken}';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode == 200) {
      setCurrentUser(response.body);
      currentUser.value = User.fromJSON(json.decode(response.body)['data']);
      return currentUser.value;
    } else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<Address>> getAddresses({bool isCourier = false}) async {
  try {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    String url;
    if (isCourier)
      url =
          '${COURIER_API_URL}delivery_addresses?$_apiToken&search=user_id:4802&searchFields=user_id:=&with=contact&orderBy=updated_at&sortedBy=desc';
    else
      url =
          '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=updated_at&sortedBy=desc';
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
        return Address.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Address.fromJSON({}));
  }
}

Future<Stream<Address>> getDefaultAddress() async {
  try {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&is_default=true';
    log(url);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    log(streamedRest.statusCode.toString());
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Address.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Address.fromJSON({}));
  }
}

Future<Address> addAddress(Address address, {bool isCourier = false}) async {
  try {
    User _user = userRepo.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    address.userId = _user.id;
    final String url =
        '${isCourier ? COURIER_API_URL : GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken';
    log(url);
    log(address.toMap().toString());
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    log(response.statusCode.toString());
    log("response" + response.body.toString());
    if (response.statusCode == 200)
      return Address.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Address.fromJSON({});
  }
}

Future<Address> updateAddress(Address address) async {
  try {
    User _user = userRepo.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    address.userId = _user.id;
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    if (response.statusCode == 200)
      return Address.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Address.fromJSON({});
  }
}

Future<Address> removeDeliveryAddress(Address address) async {
  try {
    User _user = userRepo.currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200)
      return Address.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Address.fromJSON({});
  }
}
