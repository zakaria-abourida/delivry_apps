import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/cuisine.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/slide.dart';
import '../repository/category_repository.dart';
import '../repository/cuisine_repository.dart';
import '../repository/food_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/slider_repository.dart';

class RestaurantListController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Cuisine> cuisines = <Cuisine>[];
  List<Slide> slides = <Slide>[];
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Restaurant> promotions = <Restaurant>[];
  List<Restaurant> popularRestaurants = <Restaurant>[];
  List<Review> recentReviews = <Review>[];
  List<Food> trendingFoods = <Food>[];

  RestaurantListController() {
    listenForTopRestaurants(0);
    listenForPromotions();
    // listenForSlides();
    // listenForTrendingFoods();
    listenForCategories();
    listenForCuisines();
    // listenForPopularRestaurants();
    // listenForRecentReviews();
  }

  Future<void> listenForSlides() async {
    final Stream<Slide> stream = await getSlides();
    stream.listen((Slide _slide) {
      setState(() => slides.add(_slide));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCuisines() async {
    final Stream<Cuisine> stream = await getCuisines();
    stream.listen((Cuisine _cuisine) {
      setState(() => cuisines.add(_cuisine));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForTopRestaurants(page) async {
    //final Stream<Restaurant> stream = await getNearRestaurants(deliveryAddress.value, deliveryAddress.value);
    final Stream<Restaurant> stream = await getRestaurants(page);
    stream.listen((Restaurant _restaurant) {
      setState(() => topRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPromotions() async {
    //final Stream<Restaurant> stream = await getNearRestaurants(deliveryAddress.value, deliveryAddress.value);
    final Stream<Restaurant> stream = await getPromotions();
    stream.listen((Restaurant _restaurant) {
      print(_restaurant.promo);
      if (_restaurant.promo != null && _restaurant.promo) {
        setState(() => promotions.add(_restaurant));
      }
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPopularRestaurants() async {
    final Stream<Restaurant> stream =
        await getPopularRestaurants(deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => popularRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingFoods() async {
    final Stream<Food> stream = await getTrendingFoods(deliveryAddress.value);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshRestaurantList();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshRestaurantList() async {
    setState(() {
      slides = <Slide>[];
      categories = <Category>[];
      topRestaurants = <Restaurant>[];
      popularRestaurants = <Restaurant>[];
      recentReviews = <Review>[];
      trendingFoods = <Food>[];
    });
    await listenForSlides();
    await listenForTopRestaurants(0);
    await listenForTrendingFoods();
    await listenForCategories();
    await listenForPopularRestaurants();
    await listenForRecentReviews();
  }
}
