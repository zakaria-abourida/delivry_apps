import 'package:flutter/material.dart';

import 'user.dart';

class Chat {
  String id = UniqueKey().toString();
  // message text
  String message;
  // time of the message
  int time;
  // user id who send the message
  String receiver_id;
  String sender_id;

  User receiver;
  User sender;

  Chat(this.message, this.time, this.receiver_id, this.sender_id);

  Chat.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      message = jsonMap['message'] != null ? jsonMap['message'].toString() : '';
      time = jsonMap['time'] != null ? jsonMap['time'] : 0;
      receiver_id = jsonMap['receiver_id'] != null ? jsonMap['receiver_id'].toString() : null;
      sender_id = jsonMap['sender_id'] != null ? jsonMap['sender_id'].toString() : null;
      receiver = jsonMap['receiver'] != null ? User.fromJSON(jsonMap['receiver']) : null;
      sender = jsonMap['sender'] != null ? User.fromJSON(jsonMap['sender']) : null;
    } catch (e) {
      id = null;
      message = '';
      time = 0;
      receiver = null;
      sender = null;
      receiver_id = null;
      sender_id = null;
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["message"] = message;
    map["time"] = time;
    map["receiver"] = receiver;
    map["sender"] = sender;
    map["receiver_id"] = receiver_id;
    map["sender_id"] = sender_id;
    return map;
  }
}
