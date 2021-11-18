import 'dart:ui';

import 'package:flutter/material.dart';

const COURIER_API_URL = "https://admin.webiliapp.com/api/";

class Constants {
  static const Color primaryColor = const Color.fromRGBO(232, 45, 134, 1);

  static const courierTextStyle = TextStyle(
    fontFamily: 'Gotham',
    color: Colors.black54,
    fontSize: 16,
  );

  static TextStyle courierPrimaryText = TextStyle(
      fontFamily: 'Gotham',
      color: Constants.primaryColor.withOpacity(0.9),
      fontSize: 16,
      fontWeight: FontWeight.w400);
}

class MenuItemTextStyle {
  static const TextStyle textStyle = const TextStyle(
      /*color: Constants.primaryColor,*/ fontSize: 17,
      fontWeight: FontWeight.w300);
}
