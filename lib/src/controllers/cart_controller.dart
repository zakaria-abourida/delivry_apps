import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../helpers/vdialog.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  bool iscop = false;
  double oldTotal = 0.0;
  ValueNotifier<double> total = ValueNotifier<double>(0.0);
  Coupon coupon1;
  String comment;
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();
  SharedPreferences prefs = null;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future getComment() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('comment') ? prefs.get('comment') : null;
  }

  void setComment(comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('comment', comment);
  }

  void listenForCarts({String message}) async {
    final Stream<Cart> stream = await getCart();
    carts.clear();
    stream.listen((Cart _cart) {
      log(_cart.toMap().toString());
      //coupon = _cart.food.applyCoupon(coupon);
      // coupon1 = coupon;
      carts.add(_cart);
      setState(() {});
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      } else {
        
        total.value = 0;
      }
      if (message != null) {
        vdialog.pop(context, message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }

      print(carts.isNotEmpty);
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {
    setState(() {});
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  void listenForBottomCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    removeCart(_cart).then((value) {
      setState(() {
        this.carts.remove(_cart);
      });
      vdialog.pop(context,
          S.of(context).the_food_was_removed_from_your_cart(_cart.food.name));
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).the_food_was_removed_from_your_cart(_cart.food.name)),
      // ));
    });
  }

  Future<void> emptyCart() async {
    carts.forEach((_cart) {
      removeCart(_cart).then((value) {
        setState(() {
          this.carts.remove(_cart);
        });
      });
    });
  }

  void onRemove() async {
    //Set subtotal to zero while removing
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      cartPrice = 0;
      cart.extras.forEach((element) {
        cartPrice += 0;
      });
      cartPrice *= 00;
      subTotal += 0;
    });
    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
      deliveryFee = 0;
    }
    taxAmount = 0;

    total.value = 0;

    coupon1 = coupon;
    calculateSubtotal();
    setState(() {});
  }

  void calculateSubtotal() async {
    double cartPrice = 0;
    subTotal = 0;

    carts.forEach((cart) {
      cartPrice = cart.food.price;
      cart.extras.forEach((element) {
        cartPrice += element.price;
      });
      cartPrice *= cart.quantity;
      subTotal += cartPrice;
    });

    // start

    oldTotal = subTotal;
    bool isValidRes = false;

    coupon.discountables.forEach((element) {
      if (element.discountableId == carts.elementAt(0).food.restaurant.id &&
          element.discountableType == "App\\Models\\Restaurant")
        isValidRes = true;
    });

    if (coupon.discountables.isEmpty) {
      isValidRes = true;
    }

    iscop = false;

    if (isValidRes &&
        coupon.coupon_type != null &&
        coupon.coupon_type &&
        subTotal >= 60) {
      iscop = true;
      if (coupon.discountType == 'fixed') {
        subTotal -= coupon.discount;
      } else {
        subTotal = subTotal - (subTotal * coupon.discount / 100);
      }
    }

    //end

    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
      deliveryFee = carts[0].food.restaurant.deliveryFee;
    }

    taxAmount =
        (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;

    total.value = subTotal + taxAmount + deliveryFee;

    coupon1 = coupon;

    print("total : " + total.value.toString());
    setState(() {});
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      listenForCarts();
      //saveCoupon(currentCoupon).then((value) => {
      //});
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      vdialog.popAskToCompleteProfile(
          context, S.of(context).completeYourProfileDetailsToContinue);
      /*  scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      )); */
    } else {
      DateFormat dateFormat = new DateFormat.Hm();
      DateTime now = DateTime.now();
      DateTime open = dateFormat.parse(carts[0].food.restaurant.start_time);
      open = new DateTime(
          now.year, now.month, now.day + 1, open.hour, open.minute);
      DateTime close = dateFormat.parse(carts[0].food.restaurant.end_time);
      close =
          new DateTime(now.year, now.month, now.day, close.hour, close.minute);
      // print(open);
      // print(close);
      // print(now.isBefore(open));
      // print(now.isAfter(close));
      // print(now.isBefore(open) && now.isAfter(close));

      if ((now.isBefore(open) || now.isAfter(close)) &&
          currentUser.value.id == 150) {
        //if (carts[0].food.restaurant.closed) {
        vdialog.pop(context, S.of(context).this_restaurant_is_closed_);
        /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_restaurant_is_closed_),
        )); */
      } else {
        log("RESTAURANT ====> " +
            carts.first.food.restaurant.toMap().toString());
        Navigator.of(context)
            .pushNamed('/DeliveryPickup', arguments: RouteArgument(param: carts.first.food.restaurant))
            .whenComplete(() => listenForCarts());
      }
    }
  }

  Color getCouponIconColor() {
    //print(coupon.toMap());
    //print('coupon state : '+ coupon.toMap().toString());
    bool isValidRes = false;
    coupon.discountables.forEach((element) {
      if (element.discountableId == carts.elementAt(0).food.restaurant.id &&
          element.discountableType == "App\\Models\\Restaurant")
        isValidRes = true;
    });
    if (coupon.discountables.length == 0) isValidRes = true;
    if (isValidRes && coupon?.valid == true) {
      return Colors.green;
    } else if (isValidRes && coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(context).focusColor.withOpacity(0.7);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
