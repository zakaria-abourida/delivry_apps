import 'dart:convert';
import 'dart:io';

import 'package:food_delivery_app/src/services/crashlytics_service.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import 'settings_repository.dart';

Future<Stream<Notification>> getNotifications() async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}notifications?${_apiToken}search=notifiable_id:${_user.id}&searchFields=notifiable_id:=&orderBy=created_at&sortedBy=desc&limit=10';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Notification.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Notification.fromJSON({}));
  }
}

Future<Notification> markAsReadNotifications(Notification notification) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Notification();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}notifications/${notification.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(notification.markReadMap()),
    );
    if (response.statusCode == 200)
      return Notification.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<Notification> removeNotification(Notification cart) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Notification();
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}notifications/${cart.id}?$_apiToken';
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200)
      return Notification.fromJSON(json.decode(response.body)['data']);
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return null;
  }
}

Future<void> sendNotification(String body, String title, User user) async {
  final data = {
    "notification": {"body": "$body", "title": "$title"},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "messages",
      "status": "done"
    },
    "to": "${user.deviceToken}"
  };
  final String url = 'https://fcm.googleapis.com/fcm/send';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "key=${setting.value.fcmKey}",
    },
    body: json.encode(data),
  );
  if (response.statusCode != 200) {
    print('notification sending failed');
  }
}

Future<void> newMessage(String body, String title) async {
  try {
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      return new Stream.value(null);
    }
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}messages/send?api_token=${_user.apiToken}&message=${body}'; /*&receiver_id=${_user.id}*/

    final client = new http.Client();
    final streamedRest =
        await client.send(http.Request('post', Uri.parse(url)));
    if (streamedRest.statusCode == 200)
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) {
        return Notification.fromJSON(data);
      });
    else
      throw Exception();
  } catch (e, s) {
    CrashlyticsService.recordNonFatalError(e, s);
    return new Stream.value(new Notification.fromJSON({}));
  }
}
