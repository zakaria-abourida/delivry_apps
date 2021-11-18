import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../helpers/custom_trace.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/setting.dart';
import '../services/crashlytics_service.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<Address> deliveryAddress = new ValueNotifier(new Address());
Coupon coupon = new Coupon.fromJSON({});
final navigatorKey = GlobalKey<NavigatorState>();

Future<Setting> initSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('cartCount', "0");
  Setting _setting;
  final String url = '${COURIER_API_URL}settings';
  log(url);
  try {
    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200 &&
        response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        await prefs.setString("androidVersion",
            json.decode(response.body)['data']['app_version']);
        await prefs.setString(
            "iosVersion", json.decode(response.body)['data']['ios_version']);
        await prefs.setString(
            'settings', json.encode(json.decode(response.body)['data']));
        _setting = Setting.fromJSON(json.decode(response.body)['data']);
        if (prefs.containsKey('language')) {
          _setting.mobileLanguage.value = Locale(prefs.get('language'), '');
        }
        _setting.brightness.value = prefs.getBool('isDark') ?? false
            ? Brightness.dark
            : Brightness.light;
        setting.value = _setting;
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return Setting.fromJSON({});
  }
  return setting.value;
}

Future<dynamic> setCurrentLocation() async {
  // var location = new Location();
  MapsUtil mapsUtil = new MapsUtil();
  final whenDone = new Completer();
  Address _address = new Address();
  _address = Address.fromJSON({
    'description': "Localisation actuelle",
  });
  Geolocator.requestPermission().then((value) async {
    Geolocator.getCurrentPosition().then((_locationData) async {
      String _addressName = null;
      log(_locationData.toString());
      await mapsUtil
          .getAddressName(
              new LatLng(_locationData?.latitude, _locationData?.longitude),
              setting.value.googleMapsKey)
          .then((value) async {
        _addressName = value;

        _address = Address.fromJSON({
          'address': _addressName,
          'description': "Localisation actuelle",
          'latitude': _locationData?.latitude,
          'longitude': _locationData?.longitude
        });

        print(_address.toMap());

        deliveryAddress.value = await changeCurrentLocation(_address);

 if (!whenDone.isCompleted) whenDone.complete(_address);      });
    }).timeout(Duration(seconds: 10), onTimeout: () async {
      await changeCurrentLocation(_address);
      if (!whenDone.isCompleted) whenDone.complete(_address);
      return null;
    }).catchError((e, s) {
      if (!whenDone.isCompleted) whenDone.complete(_address);
      CrashlyticsService.recordNonFatalError(e, s);
    });
  });
  return whenDone.future;
}

Future<Address> changeCurrentLocation(Address _address) async {
  if (!_address.isUnknown()) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address', json.encode(_address.toMap()));
  }
  return _address;
}

// Future<Address> getCurrentLocation() async
// {
//   Address _address = new Address();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // await prefs.clear();
//   var geoposition = null;
//   await Geolocator.getCurrentPosition().then((value) => geoposition = value);
//   // _address = Address.fromJSON(json.decode(json.encode(geoposition)));
//   _address = Address.fromJSON({
//       'address': "",
//       'description': "Localisation actuelle",
//       'latitude': geoposition?.latitude,
//       'longitude': geoposition?.longitude
//     });
//   await prefs.setString('delivery_address', json.encode(_address.toMap()));
//   await changeCurrentLocation(_address);
//   return _address;
// }

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> setDefaultLanguage(String language) async {
  if (language != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = await prefs.get('language');
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  if (messageId != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('google.message_id');
}

Future<Setting> getSettings() async {
  try {
    final String url = '${COURIER_API_URL}settings';
    log(url);
    return await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json'
    }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return Setting.fromJSON(data);
      } else {
        throw Exception();
      }
    }).catchError((_) {
      return Setting.fromJSON({});
    }).timeout(Duration(seconds: 7));
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}
