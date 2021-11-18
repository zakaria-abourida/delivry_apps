import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/zoning_fields.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../helpers/vdialog.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
  CreditCard creditCard = new CreditCard();
  bool loading = true;
  Vdialog vdialog = new Vdialog();
  num restaurantAddressId;
  num deliveryAmount;
  num driverPrice;
  num distance;
  String time;
  ZoningFields zoningFields;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    Order _order = new Order();
    _order.foodOrders = new List<FoodOrder>();
    _order.tax = carts[0].food.restaurant.defaultTax;
    _order.deliveryFee = (payment.method == 'Pay on Pickup')
        ? 0
        : carts[0].food.restaurant.deliveryFee;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    print(
        'settingRepo delivery Address ===> ${settingRepo.deliveryAddress.value.toMap().toString()}');

    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    carts.forEach((_cart) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food.price;
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders.add(_foodOrder);
    });
    _order.restaurantId = int.parse(_order.foodOrders.first.food.restaurant.id);
    if (zoningFields != null) {
      _order.restaurantAddressId = zoningFields.restaurantAddressId;
      _order.deliveryAmount = zoningFields.deliveryAmount;
      _order.distance = zoningFields.distance;
      _order.time = zoningFields.time;
    }

    print(
        'Order delivery Address ===> ${_order.deliveryAddress.toMap().toString()}');

    orderRepo.addOrder(_order, this.payment, settingRepo.coupon).then((value) {
      vdialog.succesOrderDialog(context);
      settingRepo.coupon = new Coupon.fromJSON({});
      return value;
    }).then((value) {
      if (value is Order) {
        setState(() => loading = false);
      }
    }).catchError((e) {
      print(e);
      vdialog.popOrderError(context, "La commande a échoué !");
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      vdialog.pop(context, S.of(context).payment_card_updated_successfully);

      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).payment_card_updated_successfully),
      // ));
    });
  }

  Future<void> openDialogOrderSuccess(context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Constants.primaryColor.withOpacity(1),
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 220,
                            child: Image.asset(
                              'assets/img/icons-popapp.png',
                              fit: BoxFit.fitHeight,
                              height: 250,
                            ),
                          ),
                          Container(
                            child: Text(
                              'Commande envoyé',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Text('webiliapp.com',
                                style: TextStyle(fontSize: 13)),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        })) {
    }
  }
}
