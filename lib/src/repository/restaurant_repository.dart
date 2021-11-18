import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/filter.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart';
import '../services/crashlytics_service.dart';

Future<Stream<Restaurant>> getNearRestaurants(
    Address myLocation, Address areaLocation) async {
  try {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    //final geoposition = await Geolocator.getCurrentPosition();

    _queryParams['limit'] = '6';
    if (!myLocation.isUnknown()) {
      _queryParams['myLon'] =
          settingRepo.deliveryAddress.value.longitude.toString();
      _queryParams['myLat'] =
          settingRepo.deliveryAddress.value.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Restaurant.fromJSON(data);
      });
    else
      throw Exception(streamedRest.request);
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getRestaurants(int page) async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}restaurants');
    Map<String, dynamic> _queryParams = {};
    _queryParams['limit'] = '10';
    _queryParams['offset'] = (10 * page).toString();
    _queryParams['myLon'] =
        settingRepo.deliveryAddress.value.longitude.toString();
    _queryParams['myLat'] =
        settingRepo.deliveryAddress.value.latitude.toString();

    uri = uri.replace(queryParameters: _queryParams);
    CrashlyticsService.crashlytics.log(uri.toString());
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Restaurant.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getPromotions() async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}restaurants');

    Map<String, dynamic> _queryParams = {};

    //final geoposition = await Geolocator.getCurrentPosition();

    // _queryParams['limit'] = '10';
    // _queryParams['offset'] = (10 * page).toString();

    _queryParams['myLon'] =
        settingRepo.deliveryAddress.value.longitude.toString();
    _queryParams['myLat'] =
        settingRepo.deliveryAddress.value.latitude.toString();

    /*_queryParams['areaLon'] = geoposition.longitude.toString();
    _queryParams['areaLat'] = geoposition.latitude.toString(); */

    uri = uri.replace(queryParameters: _queryParams);
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
        return Restaurant.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getPopularRestaurants(Address myLocation) async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

    _queryParams['limit'] = '6';
    _queryParams['popular'] = 'all';
    if (!myLocation.isUnknown()) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Restaurant.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> searchRestaurants(
    String search, Address address) async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}restaurants');
    Map<String, dynamic> _queryParams = {};
    _queryParams['search'] = 'name:$search#description:$search';
    _queryParams['searchFields'] = 'name:like#description:like';
    _queryParams['limit'] = '5';
    if (!address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    uri = uri.replace(queryParameters: _queryParams);
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
        return Restaurant.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getRestaurant(String id, {Address address}) async {
  try {
    Uri uri = Uri.parse(
        '${GlobalConfiguration().getValue('api_base_url')}restaurants/$id');
    Map<String, dynamic> _queryParams = {};
    if (address!= null && !address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    _queryParams['with'] = 'users';
    uri = uri.replace(queryParameters: _queryParams);
    log(uri.toString());
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) => Restaurant.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Review>> getRestaurantReviews(String id) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?with=user&search=restaurant_id:$id';
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
        return Review.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Stream<Review>> getRecentReviews() async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Review.fromJSON(data);
      });
    throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Review> addRestaurantReview(Review review, Restaurant restaurant) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews';
    final client = new http.Client();
    review.user = currentUser.value;
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofRestaurantToMap(restaurant)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return Review.fromJSON({});
  }
}

Future<Review> addDeliveryManReview(Review review, String driver_id) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}driver_reviews';
    final client = new http.Client();
    review.user = currentUser.value;
    log(review.ofDeliveryManToMap(driver_id).toString());
    log(url);
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofDeliveryManToMap(driver_id)),
    );
    if (response.statusCode == 200)
      return Review.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return Review.fromJSON({});
  }
}

Future<Stream<Restaurant>> getRestaurantsByCuisine(cuisineId) async {
  try {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}restaurants?cuisines[]=$cuisineId';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Restaurant.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}
