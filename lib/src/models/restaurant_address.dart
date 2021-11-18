import 'dart:convert';

class RestaurantAddress {
  num id;
  String description;
  String address;
  String latitude;
  String longitude;
  num restaurantId;
  num zoneId;
  String createdAt;
  String updatedAt;
  RestaurantAddress({
    this.id,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.restaurantId,
    this.zoneId,
    this.createdAt,
    this.updatedAt,
  });

  RestaurantAddress copyWith({
    num id,
    String description,
    String address,
    String latitude,
    String longitude,
    num restaurantId,
    num zoneId,
    String createdAt,
    String updatedAt,
  }) {
    return RestaurantAddress(
      id: id ?? this.id,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      restaurantId: restaurantId ?? this.restaurantId,
      zoneId: zoneId ?? this.zoneId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'restaurantId': restaurantId,
      'zoneId': zoneId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RestaurantAddress.fromMap(Map<String, dynamic> map) {
    return RestaurantAddress(
      id: map['id'],
      description: map['description'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      restaurantId: map['restaurantId'],
      zoneId: map['zoneId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantAddress.fromJson(String source) =>
      RestaurantAddress.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RestaurantAddress(id: $id, description: $description, address: $address, latitude: $latitude, longitude: $longitude, restaurantId: $restaurantId, zoneId: $zoneId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
