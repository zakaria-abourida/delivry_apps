import 'package:flutter/material.dart';

class CourierIcon extends StatelessWidget {
  final bool isEnabled;
  final Function onTapCallBack;

  const CourierIcon({Key key, this.isEnabled = true, this.onTapCallBack})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapCallBack,
        child: Image.asset(
          isEnabled
              ? 'assets/img/icon-abracadabra-.png'
              : 'assets/img/icon-abraca.png',
          height: 150,
        ));
  }
}
