import '../helpers/custom_trace.dart';
import '../models/category.dart';
import '../models/extra.dart';
import '../models/extra_group.dart';
import '../models/media.dart';
import '../models/nutrition.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import 'coupon.dart';

class Food {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String weight;
  String unit;
  String packageItemsCount;
  String parent_id;
  String category_id;
  bool featured;
  bool is_parent;
  bool deliverable;
  Restaurant restaurant;
  Category category;
  List<Food> foods;
  List<Extra> extras;
  List<ExtraGroup> extraGroups;
  List<Review> foodReviews;
  List<Nutrition> nutritions;

  Food();

  Food.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0
          ? discountPrice
          : jsonMap['price'] != null
              ? jsonMap['price'].toDouble()
              : 0.0;
      description = jsonMap['description'];
      ingredients = jsonMap['ingredients'];
      weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      packageItemsCount = jsonMap['package_items_count'].toString();
      parent_id = jsonMap['parent_id'].toString();
      category_id = jsonMap['category_id'].toString();
      featured = jsonMap['featured'] ?? false;
      is_parent = jsonMap['is_parent'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
      restaurant = jsonMap['restaurant'] != null
          ? Restaurant.fromJSON(jsonMap['restaurant'])
          : Restaurant.fromJSON({});
      category = jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : Category.fromJSON({});
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      foods = jsonMap['foods'] != null && (jsonMap['foods'] as List).length > 0
          ? List.from(jsonMap['foods'])
              .map((element) => Food.fromJSON(element))
              .toSet()
              .toList()
          : [];
      extras =
          jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
              ? List.from(jsonMap['extras'])
                  .map((element) => Extra.fromJSON(element))
                  .toSet()
                  .toList()
              : [];
      extraGroups = jsonMap['extra_groups'] != null &&
              (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups'])
              .map((element) => ExtraGroup.fromJSON(element))
              .toSet()
              .toList()
          : [];
      foodReviews = jsonMap['food_reviews'] != null &&
              (jsonMap['food_reviews'] as List).length > 0
          ? List.from(jsonMap['food_reviews'])
              .map((element) => Review.fromJSON(element))
              .toSet()
              .toList()
          : [];
      nutritions = jsonMap['nutrition'] != null &&
              (jsonMap['nutrition'] as List).length > 0
          ? List.from(jsonMap['nutrition'])
              .map((element) => Nutrition.fromJSON(element))
              .toSet()
              .toList()
          : [];
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      weight = '';
      ingredients = '';
      unit = '';
      packageItemsCount = '';
      parent_id = '';
      category_id = '';
      featured = false;
      deliverable = false;
      restaurant = Restaurant.fromJSON({});
      category = Category.fromJSON({});
      image = new Media();
      foods = [];
      extras = [];
      extraGroups = [];
      foodReviews = [];
      nutritions = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    map["is_parent"] = is_parent.toString();
    map["parent_id"] = parent_id;
    map["category_id"] = category_id;
    return map;
  }

  double getRate() {
    double _rate = 0;
    foodReviews.forEach((e) => _rate += double.parse(e.rate));
    _rate = _rate > 0 ? (_rate / foodReviews.length) : 0;
    return _rate;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  Coupon applyCoupon(Coupon coupon) {
    if (coupon.code != '') {
      if (coupon.valid == null) {
        coupon.valid = false;
      }

      if (coupon.coupon_type == null) {
        coupon.coupon_type = false;
      }

      if (coupon.coupon_type) {
        coupon = _couponDiscountPrice(coupon);
      } else {
        coupon.discountables.forEach((element) {
          if (!coupon.valid) {
            if (element.discountableType == "App\\Models\\Food") {
              if (element.discountableId == id) {
                coupon = _couponDiscountPrice(coupon);
              }
            } else if (element.discountableType == "App\\Models\\Restaurant") {
              if (element.discountableId == restaurant.id) {
                coupon = _couponDiscountPrice(coupon);
              }
            } else if (element.discountableType == "App\\Models\\Category") {
              if (element.discountableId == category.id) {
                coupon = _couponDiscountPrice(coupon);
              }
            }
          }
        });
      }
    }
    return coupon;
  }

  Coupon _couponDiscountPrice(Coupon coupon) {
    coupon.valid = true;
    //discountPrice = price;
    // if (!coupon.coupon_type) {
    //   if (coupon.discountType == 'fixed') {
    //     price -= coupon.discount;
    //   } else {
    //     price = price - (price * coupon.discount / 100);
    //   }
    //   if (price < 0) price = 0;
    // }

    return coupon;
  }

  // Coupon _couponDiscountPrice(Coupon coupon) {
  //   if (!coupon.coupon_type) {
  //     coupon.valid = true;
  //     discountPrice = price;
  //     if (coupon.discountType == 'fixed') {
  //       price -= coupon.discount;
  //     } else {
  //       price = price - (price * coupon.discount / 100);
  //     }
  //     if (price < 0) price = 0;
  //   }
  //   return coupon;
  // }

}
