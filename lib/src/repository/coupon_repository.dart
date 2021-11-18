import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/coupon.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../services/crashlytics_service.dart';

Future<Stream<Coupon>> verifyCoupon(String code) async {
  try {
    Uri uri = Helper.getUri('api/coupons');
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    Map<String, dynamic> query = {
      'api_token': _user.apiToken,
      'with': 'discountables',
      'search': 'code:$code',
      'searchFields': 'code:=',
    };
    uri = uri.replace(queryParameters: query);
    log(uri.toString());
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        log(data.toString());
        return Coupon.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Coupon.fromJSON({}));
  }
}

Future<Coupon> saveCoupon(Coupon coupon) async {
  try {
    if (coupon != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('coupon', json.encode(coupon.toMap()));
    }
    return coupon;
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return coupon;
  }
}

Future<Coupon> getCoupon() async {
  try {
    Coupon _coupon = Coupon.fromJSON({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('coupon')) {
      _coupon = Coupon.fromJSON(json.decode(await prefs.get('coupon')));
    }
    return _coupon;
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}
