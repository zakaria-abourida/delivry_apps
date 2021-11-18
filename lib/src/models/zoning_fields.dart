import 'dart:convert';

class ZoningFields {
  num restaurantAddressId;
  num deliveryAmount;
  num driverPrice;
  num distance;
  String time;
  ZoningFields({
    this.restaurantAddressId,
    this.deliveryAmount,
    this.driverPrice,
    this.distance,
    this.time,
  });

  ZoningFields copyWith({
    num restaurantAddressId,
    num deliveryAmount,
    num driverPrice,
    num distance,
    String time,
  }) {
    return ZoningFields(
      restaurantAddressId: restaurantAddressId ?? this.restaurantAddressId,
      deliveryAmount: deliveryAmount ?? this.deliveryAmount,
      driverPrice: driverPrice ?? this.driverPrice,
      distance: distance ?? this.distance,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantAddressId': restaurantAddressId,
      'deliveryAmount': deliveryAmount,
      'driverPrice': driverPrice,
      'distance': distance,
      'time': time,
    };
  }

  factory ZoningFields.fromMap(Map<String, dynamic> map) {
    return ZoningFields(
      restaurantAddressId: map['restaurantAddressId'],
      deliveryAmount: map['deliveryAmount'],
      driverPrice: map['driverPrice'],
      distance: map['distance'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoningFields.fromJson(String source) =>
      ZoningFields.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ZoningFields(restaurantAddressId: $restaurantAddressId, deliveryAmount: $deliveryAmount, driverPrice: $driverPrice, distance: $distance, time: $time)';
  }
}
