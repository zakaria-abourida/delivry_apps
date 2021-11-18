import '../helpers/custom_trace.dart';

class ExtraGroup {
  String id;
  String name;
  int max_select;
  int min_select;

  ExtraGroup();

  ExtraGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      max_select = jsonMap['max_select'];
      min_select = jsonMap['min_select'];
    } catch (e) {
      id = '';
      name = '';
      max_select = max_select;
      min_select = min_select;
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["max_select"] = max_select;
    map["min_select"] = min_select;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
