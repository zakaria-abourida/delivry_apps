import 'package:flutter/material.dart';

import '../../constant.dart';

class AppBarWebili extends StatefulWidget implements PreferredSizeWidget {
  //Bg Color = "primary " or "white" or "grey"
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final String bgColor;
  final VoidCallback beforeGoBack;
  final bool showActionIcon;
  final bool showLeading;

  AppBarWebili(
      {Key key,
      this.parentScaffoldKey,
      this.bgColor = "primary",
      this.beforeGoBack = null,
      this.showActionIcon = true,
      this.showLeading = true})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarWebiliState createState() => _AppBarWebiliState();
}

class _AppBarWebiliState extends State<AppBarWebili> {
  @override
  Widget build(BuildContext context) {
    String colors = widget.bgColor;
    return AppBar(
      actions: [
        widget.showActionIcon
            ? IconButton(
                onPressed: () =>
                    widget.parentScaffoldKey.currentState.openDrawer(),
                color:
                    colors == "primary" ? Colors.white : Constants.primaryColor,
                icon: Icon(Icons.person),
                iconSize: 35,
              )
            : Container()
      ],
      leading: widget.showLeading
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              color:
                  colors == "primary" ? Colors.white : Constants.primaryColor,
              // Within the SecondRoute widget
              onPressed: () {
                if (widget.beforeGoBack != null)
                  widget.beforeGoBack();
                else
                  Navigator.pop(context);
              })
          : Container(),
      backgroundColor: colors == "primary"
          ? Constants.primaryColor
          : (colors == "grey" ? Colors.grey[200] : Colors.white),
      centerTitle: true,
      title: Image.asset(
        'assets/img/logo.png',
        fit: BoxFit.fitHeight,
        height: 130,
        color: colors == "primary" ? Colors.white : Constants.primaryColor,
      ),
      elevation: 0,
    );
  }
}
