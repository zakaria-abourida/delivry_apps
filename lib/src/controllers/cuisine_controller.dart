import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/vdialog.dart';
import '../models/cart.dart';
import '../models/cuisine.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../repository/cart_repository.dart';
import '../repository/cuisine_repository.dart';
import '../repository/food_repository.dart';
import '../repository/restaurant_repository.dart';

class CuisineController extends ControllerMVC {
  List<Food> foods = <Food>[];
  List<Restaurant> restaurants = <Restaurant>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Cuisine cuisine;
  bool loadCart = false;
  List<Cart> carts = [];
  Vdialog vdialog = new Vdialog();

  CuisineController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForFoodsByCuisine({String id, String message}) async {
    final Stream<Food> stream = await getFoodsByCuisine(id);
    stream.listen((Food _food) {
      setState(() {
        foods.add(_food);
      });
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        vdialog.pop(context,message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
    });
  }


  void listenForRestaurantsByCuisine({String id, String message}) async {
    final Stream<Restaurant> stream = await getRestaurantsByCuisine(id);
    stream.listen((Restaurant _restaurant) {
      setState(() {
        restaurants.add(_restaurant);
      });
    }, onError: (a) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        vdialog.pop(context,message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
    });
  }

  void listenForCuisine({String id, String message}) async {
    final Stream<Cuisine> stream = await getCuisine(id);
    stream.listen((Cuisine _cuisine) {
      setState(() => cuisine = _cuisine);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        vdialog.pop(context,message);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
    });
  }

  Future<void> listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameRestaurants(Food food) {
    if (carts.isNotEmpty) {
      return carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToCart(Food food, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.food = food;
    _newCart.extras = [];
    _newCart.quantity = 1;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity++;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        vdialog.pop(context,S.of(context).this_food_was_added_to_cart);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(),
        // ));
      });
    } else {
      // the food doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        if (reset) carts.clear();
        carts.add(_newCart);
        vdialog.pop(context,S.of(context).this_food_was_added_to_cart);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(),
        // ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart), orElse: () => null);
  }

  Future<void> refreshCuisine() async {
    foods.clear();
    cuisine = new Cuisine();
    listenForFoodsByCuisine(message: S.of(context).cuisine_refreshed_successfuly);
    listenForCuisine(message: S.of(context).cuisine_refreshed_successfuly);
  }
}
