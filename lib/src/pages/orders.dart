import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../controllers/order_controller.dart';
import '../elements/CourierOrderItemWidget.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }
  @override
  void initState() {
    
    _con.listenForOrdersTimer();
    _con.listenForOrdersHistoryTimer();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
              color: Colors.white,
              icon: Icon(Icons.person),
              iconSize: 35,
            )
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              color: Colors.white,
              // Within the SecondRoute widget
              onPressed: () {
                // DateTime now = DateTime.now();
                // if (currentBackPressTime == null ||
                //     now.difference(currentBackPressTime) >
                //         Duration(seconds: 2)) {
                //   currentBackPressTime = now;
                //   Fluttertoast.showToast(
                //       msg: S.of(context).tapAgainToGetBackToMainMenu);
                //   return Future.value(false);
                // }
                Navigator.of(context).pushReplacementNamed('/Home');
                // return Future.value(true);
              }),
          backgroundColor: Constants.primaryColor,
          centerTitle: true,
          title: Image.asset(
            'assets/img/logo.png',
            fit: BoxFit.fitHeight,
            height: 130,
            color: Colors.white,
          ),
          elevation: 0,
          bottom: TabBar(controller: tabController, tabs: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.fastfood,
                size: 25,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.delivery_dining,
                size: 25,
                color: Colors.white,
              ),
            ),
          ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _foodOrderTab(),
            _courierOrderTab(),
          ],
        ));
  }

  _foodOrderTab() {
    return currentUser.value.apiToken == null
        ? PermissionDeniedWidget()
        : _con.orders.isEmpty
            ? EmptyOrdersWidget()
            : RefreshIndicator(
                onRefresh: _con.refreshOrders,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: SearchBarWidget(),
                      // ),
                      SizedBox(height: 20),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.orders.length,
                        itemBuilder: (context, index) {
                          var _order = _con.orders.elementAt(index);
                          return OrderItemWidget(
                            expanded: index == 0 ? true : false,
                            order: _order,
                            onCanceled: (e) {
                              _con.doCancelOrder(_order);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20);
                        },
                      ),
                    ],
                  ),
                ),
              );
  }

  _courierOrderTab() {
    return currentUser.value.apiToken == null
        ? PermissionDeniedWidget()
        : _con.courierOrders.isEmpty
            ? EmptyOrdersWidget()
            : RefreshIndicator(
                onRefresh: _con.refreshOrders,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: SearchBarWidget(),
                      // ),
                      SizedBox(height: 20),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.courierOrders.length,
                        itemBuilder: (context, index) {
                          var _order = _con.courierOrders.elementAt(index);
                          return CourierOrderItemWidget(
                            expanded: index == 0 ? true : false,
                            order: _order,
                            /*  onCanceled: (e) {
                              _con.doCancelOrder(_order);
                            }, */
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20);
                        },
                      ),
                    ],
                  ),
                ),
              );
  }
}
