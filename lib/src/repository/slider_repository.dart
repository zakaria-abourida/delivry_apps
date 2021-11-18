import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/slide.dart';
import '../services/crashlytics_service.dart';

Future<Stream<Slide>> getSlides() async {
  try {
    Uri uri = Helper.getUri('api/slides');
    Map<String, dynamic> _queryParams = {
      'with': 'food;restaurant',
      'search': 'enabled:1',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    uri = uri.replace(queryParameters: _queryParams);

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) => Slide.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Slide.fromJSON({}));
  }
}
