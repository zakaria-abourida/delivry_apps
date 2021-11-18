class DistanceMatrix {
  DistanceOrDuration distance;
  DistanceOrDuration duration;
  String status;

  DistanceMatrix({this.distance, this.duration, this.status});

  DistanceMatrix.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new DistanceOrDuration.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new DistanceOrDuration.fromJson(json['duration'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class DistanceOrDuration {
  String text;
  int value;

  DistanceOrDuration({this.text, this.value});

  DistanceOrDuration.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}
