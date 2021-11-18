import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/vdialog.dart';
import '../models/courier_order.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  List<CourierOrder> courierOrders = <CourierOrder>[];
  Timer orderTimer ;
  Timer orderCourierTimer ;


  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOrders();
    listenForCourierOrders();
  }
   void listenForOrdersTimer() {
    listenForOrders();
    orderTimer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => listenForOrders());
  }
    void listenForOrdersHistoryTimer() {
    listenForCourierOrders();
    orderCourierTimer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => listenForCourierOrders());
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    orders.clear();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (e) {
      print(e);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        vdialog.pop(context, message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
    });
  }

  void doCancelOrder(Order order) {
    cancelOrder(order).then((value) {
      setState(() {
        order.active = false;
      });
    }).catchError((e) {
      vdialog.pop(context, e);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(e),
      // ));
    }).whenComplete(() {
      //refreshOrders();

      vdialog.pop(
          context, S.of(context).orderThisorderidHasBeenCanceled(order.id));
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).orderThisorderidHasBeenCanceled(order.id)),
      // ));
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(context).order_refreshed_successfuly);
  }



  void listenForCourierOrders({String message}) async {
    final Stream<CourierOrder> stream = await getCourierOrders();
    courierOrders.clear();
    stream.listen((CourierOrder _order) {
      setState(() {
        courierOrders.add(_order);
      });
    }, onError: (e) {
      print(e);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        vdialog.pop(context, message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),         
        // ));
      }
    });
  }
}
