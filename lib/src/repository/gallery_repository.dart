import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/gallery.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';
import '../services/crashlytics_service.dart';

Future<Stream<Gallery>> getGalleries(String idRestaurant) async {
  try {
    User _user = currentUser.value;
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}galleries?${_apiToken}search=restaurant_id:$idRestaurant';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) => Gallery.fromJSON(data));
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}
