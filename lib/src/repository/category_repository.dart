import 'dart:convert';

import 'package:food_delivery_app/src/services/crashlytics_service.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/filter.dart';

Future<Stream<Category>> getCategories() async {
  try {
    Uri uri = Helper.getUri('api/categories');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    filter.delivery = false;
    filter.open = false;

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
          .map((data) => Category.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Stream<Category>> getCategoriesOfRestaurant(String restaurantId) async {
  try {
    Uri uri = Helper.getUri('api/categories');
    Map<String, dynamic> _queryParams = {'restaurant_id': restaurantId};

    uri = uri.replace(queryParameters: _queryParams);
    print(uri);
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        // print(Category.fromJSON(data).id);
        return Category.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Stream<Category>> getCategory(String id) async {
  try {
    final String url =
        '${GlobalConfiguration().get('api_base_url')}categories/$id';
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) => Category.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Category.fromJSON({}));
  }
}
