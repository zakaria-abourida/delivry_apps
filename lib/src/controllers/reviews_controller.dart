import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/vdialog.dart';
import '../models/food.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/review.dart';
import '../repository/food_repository.dart' as foodRepo;
import '../repository/order_repository.dart';
import '../repository/restaurant_repository.dart' as restaurantRepo;

class ReviewsController extends ControllerMVC {
  Review restaurantReview;
  Review deliveryManReview;
  List<Review> foodsReviews = [];
  Order order;
  List<Food> foodsOfOrder = [];
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();

  ReviewsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.restaurantReview = new Review.init("0");
    this.deliveryManReview = new Review.init("3");
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        foodsReviews =
            List.generate(order.foodOrders.length, (_) => new Review.init("0"));
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      getFoodsOfOrder();
      if (message != null) {
        vdialog.pop(context, message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
    });
  }

  void addFoodReview(Review _review, Food _food) async {
    foodRepo.addFoodReview(_review, _food).then((value) {
      vdialog.pop(context, "Merci d'avoir évalué votre livreur !");
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(/*S.of(context).the_food_has_been_rated_successfully*/"Le livreur a été évalué avec succès"),
      // ));
    });
  }

  void addRestaurantReview(Review _review) async {
    restaurantRepo
        .addRestaurantReview(_review, this.order.foodOrders[0].food.restaurant)
        .then((value) {
      refreshOrder();
      //vdialog.pop(context,S.of(context).the_restaurant_has_been_rated_successfully);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).the_restaurant_has_been_rated_successfully),
      // ));
    });
  }

  void addDeliveryManReview(Review _review, {bool isCourier = false}) async {
    restaurantRepo
        .addDeliveryManReview(_review, this.order.driver_id)
        .then((value) {
      if (isCourier == false)
        refreshOrder();
      else {
        Navigator.of(context).pushReplacementNamed('/Home');
      }
      //vdialog.pop(context,S.of(context).the_delivery_man_has_been_rated_successfully);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).the_delivery_man_has_been_rated_successfully),
      // ));
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(
        orderId: order.id,
        message: S.of(context).reviews_refreshed_successfully);
  }

  void getFoodsOfOrder() {
    this.order.foodOrders.forEach((_foodOrder) {
      if (!foodsOfOrder.contains(_foodOrder.food)) {
        foodsOfOrder.add(_foodOrder.food);
      }
    });
  }
}
