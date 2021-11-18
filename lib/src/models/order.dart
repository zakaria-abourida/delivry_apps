import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/food_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';

class Order {
  String id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  String hint;
  String comment;
  bool active;
  DateTime dateTime;
  User user;
  Payment payment;
  Address deliveryAddress;
  String driver_id;
  String deliveryAddressId;
  num discountAmount;
  String discountType;
  num restaurantId;
  num restaurantAddressId;
  num deliveryAmount;
  num driverPrice;
  num distance;
  String time;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      driver_id = jsonMap['driver_id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      comment = jsonMap['comment'] != null ? jsonMap['comment'].toString() : '';
      active = jsonMap['active'] ?? false;
      orderStatus = jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : OrderStatus.fromJSON({});

      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null
          ? User.fromJSON(jsonMap['user'])
          : User.fromJSON({});
      deliveryAddress = jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : Address.fromJSON({});
      payment = jsonMap['payment'] != null
          ? Payment.fromJSON(jsonMap['payment'])
          : Payment.fromJSON({});
      foodOrders = jsonMap['food_orders'] != null
          ? List.from(jsonMap['food_orders'])
              .map((element) => FoodOrder.fromJSON(element))
              .toList()
          : [];
      deliveryAddressId = jsonMap['delivery_address_id'].toString();
      discountAmount = jsonMap['discount_amount']?.toDouble() ?? null;
      restaurantId = jsonMap['restaurant_id'] ?? null;
      restaurantAddressId = jsonMap['restaurant_address_id'] ?? null;
      deliveryAmount = jsonMap['delivery_amount'] ?? 0;
      driverPrice = jsonMap['driver_price'] ?? 0;
      distance = jsonMap['distance'] ?? '0';
      time = jsonMap['time'] ?? '0';
    } catch (e) {
      id = '';
      driver_id = '';
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      comment = '';
      active = false;
      orderStatus = OrderStatus.fromJSON({});
      dateTime = DateTime(0);
      user = User.fromJSON({});
      payment = Payment.fromJSON({});
      deliveryAddress = Address.fromJSON({});
      foodOrders = [];
      deliveryAddressId = '';
      discountAmount = null;
      discountType = null;
      restaurantId = null;
      restaurantAddressId = null;
      deliveryAmount = 0;
      driverPrice = 0;
      distance = 0;
      time = '0';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["driver_id"] = driver_id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map['comment'] = comment;
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders?.map((element) => element.toMap())?.toList();
    map["payment"] = payment?.toMap();
    map["delivery_address_id"] = deliveryAddress?.id;
    map["discount_amount"] = discountAmount;
    map["discount_type"] = discountType;
    map['restaurant_id'] = this.restaurantId;
    map['restaurant_address_id'] = this.restaurantAddressId;
    map['delivery_amount'] = this.deliveryAmount;
    map['driver_price'] = this.driverPrice;
    map['distance'] = this.distance;
    map['time'] = this.time;

    /*  if (!deliveryAddress.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress?.id;
    } 
    map["delivery_address_id"] = deliveryAddressId; */
    return map;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    if (orderStatus?.id != null && orderStatus?.id == '1')
      map["active"] = false;
    return map;
  }

  bool canCancelOrder() {
    return this.active == true &&
        this.orderStatus.id == '1'; // 1 for order received status
  }
}
