import 'package:location/location.dart';

import '../helpers/custom_trace.dart';
import 'contact.dart';

class Address {
  String id;
  String description;
  String address;
  double latitude;
  double longitude;
  bool isDefault;
  String userId;
  Contact contact;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      latitude =
          jsonMap['latitude'] != null ? jsonMap['latitude'].toDouble() : null;
      longitude =
          jsonMap['longitude'] != null ? jsonMap['longitude'].toDouble() : null;
      isDefault = jsonMap['is_default'] ?? false;
      contact = jsonMap['contact'] != null
          ? Contact.fromMap(jsonMap['contact'])
          : null;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  // Driver have a LatLng properties called 'lat' and 'lng' that difference  of Address.fromJSON function above
  Address.fromJSONForDriver(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      latitude = jsonMap['lat'] != null ? double.parse(jsonMap['lat']) : null;
      longitude =
          jsonMap['long'] != null ? double.parse(jsonMap['long']) : null;
      isDefault = jsonMap['is_default'] ?? false;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  bool isUnknown() {
    return latitude == null ||
        longitude == null; //|| id == null || id == 'null';
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    if (contact != null) {
      map['contact'] = contact.toJson();
    }
    return map;
  }

  Map courierToMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    map["contact[name]"] = contact.name;
    map["contact[phone]"] = contact.phone;
    return map;
  }

  LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
