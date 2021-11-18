import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/cuisine.dart';
import '../services/crashlytics_service.dart';

Future<Stream<Cuisine>> getCuisines() async {
  try {
    final String url =
        '${GlobalConfiguration().get('api_base_url')}cuisines?orderBy=updated_at&sortedBy=desc';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Cuisine.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Stream<Cuisine>> getCuisine(String id) async {
  try {
    final String url =
        '${GlobalConfiguration().get('api_base_url')}cuisines/$id';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .map((data) => Cuisine.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Cuisine.fromJSON({}));
  }
}
