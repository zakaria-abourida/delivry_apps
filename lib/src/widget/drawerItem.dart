import 'package:flutter/material.dart';

import '../../constant.dart';

class DrawerItem extends StatefulWidget {
  DrawerItem({Key key, this.text = "", this.navigate}) : super(key: key);

  final String text;
  final navigate;
  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 20),
      child: Column(
        children: [
          Divider(color: Colors.grey, thickness: 1),
          InkWell(
            onTap: () {
              widget.navigate();
            },
            child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.text,
                          style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w300)),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Constants.primaryColor)
                    ])),
          ),
        ],
      ),
    ));
  }
}
