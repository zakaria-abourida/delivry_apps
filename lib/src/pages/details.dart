import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../models/route_argument.dart';
import 'menu_list.dart';

class DetailsWidget extends StatefulWidget {
  RouteArgument routeArgument;
  dynamic currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  DetailsWidget({
    Key key,
    this.parentScaffoldKey,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  RestaurantController _con;
  Widget currentPage;

  _DetailsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  initState() {
    _selectTab(widget.currentTab);
    super.initState();
  }

/*   @override
  void didUpdateWidget(DetailsWidget oldWidget) {
    var t = currentPage;
    super.didUpdateWidget(oldWidget);
  } */

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          _con
              .listenForRestaurant(id: widget.routeArgument.param)
              .then((value) {
           /*  setState(() {
              currentPage = MenuWidget(
                  routeArgument: RouteArgument(param: _con.restaurant));
            }); */
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        body: _con.restaurant != null
            ? MenuWidget(routeArgument: RouteArgument(param: _con.restaurant))
            : CircularLoadingWidget(height: 400));
  }
}
