import 'dart:convert';

import 'media.dart';
import 'payment.dart';

class CourierOrder {
  int id;
  int userId;
  int driverId;
  int paymentId;
  int deliveryAddressId;
  int collectAddressId;
  String comment;
  String hour;
  String duration;
  double distance;
  double amount;
  double price;
  double deliveryFee;
  int orderStatusId;
  Payment payment;
  bool hasMedia;
  List<Media> media;
  bool active;
  DateTime date;
  CourierOrder(
      {this.id,
      this.userId,
      this.driverId,
      this.paymentId,
      this.deliveryAddressId,
      this.collectAddressId,
      this.comment,
      this.hour,
      this.duration,
      this.distance,
      this.amount,
      this.price,
      this.deliveryFee,
      this.orderStatusId,
      this.payment,
      this.hasMedia,
      this.media,
      this.active,
      this.date});

  CourierOrder copyWith({
    int id,
    int userId,
    int driverId,
    int paymentId,
    int deliveryAddressId,
    int collectAddressId,
    String comment,
    String hour,
    String duration,
    double distance,
    double amount,
    double price,
    double deliveryFee,
    int orderStatusId,
    Payment payment,
    bool hasMedia,
    List<Media> media,
    bool active,
    DateTime date,
  }) {
    return CourierOrder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      paymentId: paymentId ?? this.paymentId,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      collectAddressId: collectAddressId ?? this.collectAddressId,
      comment: comment ?? this.comment,
      hour: hour ?? this.hour,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      orderStatusId: orderStatusId ?? this.orderStatusId,
      payment: payment ?? this.payment,
      hasMedia: hasMedia ?? this.hasMedia,
      media: media ?? this.media,
      active: active ?? this.active,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'driver_id': driverId,
      'payment_id': paymentId,
      'delivery_address_id': deliveryAddressId,
      'collect_address_id': collectAddressId,
      'comment': comment,
      'hour': hour,
      'duration': duration,
      'distance': distance,
      'amount': amount,
      'price': price,
      'delivery_fee': deliveryFee,
      'order_status_id': orderStatusId,
      'has_media': hasMedia,
      'payment': payment.toMap(),
      'media': media?.map((x) => x.toMap())?.toList(),
    };
  }

  factory CourierOrder.fromMap(Map<String, dynamic> map) {
    return CourierOrder(
      id: map['id'],
      userId: map['user_id'],
      driverId: map['driver_id'],
      paymentId: map['payment_id'],
      deliveryAddressId: map['delivery_address_id'],
      collectAddressId: map['collect_address_id'],
      comment: map['comment'],
      hour: map['hour'],
      duration: map['duration'],
      distance: map['distance'],
      amount: map['amount'],
      price: map['price'] != null ? map['price'].toDouble() : null,
      deliveryFee: map['delivery_fee'],
      orderStatusId: map['order_status_id'],
      payment: Payment.fromJSON(map['payment'] != null ? map['payment'] : {}),
      hasMedia: map['has_media'],
      media: List<Media>.from(map['media']?.map((x) => Media.fromJSON(x))),
      active: map['active'],
      date: DateTime.parse(map['updated_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CourierOrder.fromJson(String source) =>
      CourierOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CourierOrder(id: $id, userId: $userId, driverId: $driverId, paymentId: $paymentId, deliveryAddressId: $deliveryAddressId, collectAddressId: $collectAddressId, comment: $comment, hour: $hour, duration: $duration, distance: $distance, amount: $amount, price: $price, deliveryFee: $deliveryFee, orderStatusId: $orderStatusId, payment: $payment, hasMedia: $hasMedia, media: $media,active: $active,date: $date)';
  }
}
