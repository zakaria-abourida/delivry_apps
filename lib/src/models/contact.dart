import 'dart:convert';

class Contact {
  int id;
  int userId;
  String name;
  String phone;
  int addressId;
  bool isMe;
  String createdAt;
  String updatedAt;
  Contact({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.addressId,
    this.isMe,
    this.createdAt,
    this.updatedAt,
  });

  Contact copyWith({
    int id,
    int userId,
    String name,
    String phone,
    int addressId,
    bool isMe,
    String createdAt,
    String updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressId: addressId ?? this.addressId,
      isMe: isMe ?? this.isMe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'addressId': addressId,
      'isMe': isMe,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      phone: map['phone'],
      addressId: map['addressId'],
      isMe: map['isMe'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Contact(id: $id, userId: $userId, name: $name, phone: $phone, addressId: $addressId, isMe: $isMe, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
