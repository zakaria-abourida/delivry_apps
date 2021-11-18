import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:food_delivery_app/src/services/crashlytics_service.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../models/Step.dart';
import '../models/distance_matrix.dart';
import '../repository/settings_repository.dart';

class MapsUtil {
  static const BASE_URL =
      "https://maps.googleapis.com/maps/api/directions/json?";
  static const DISTANCE_MATRIX_API =
      "https://maps.googleapis.com/maps/api/distancematrix/json";

  static MapsUtil _instance = new MapsUtil.internal();

  MapsUtil.internal();

  factory MapsUtil() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(BASE_URL + url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      List<LatLng> steps;
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        print(CustomTrace(StackTrace.current, message: e));
        // throw new Exception(e);
      }

      return steps;
    });
  }

  List<LatLng> parseSteps(final responseBody) {
    List<Step> _steps = responseBody.map<Step>((json) {
      return new Step.fromJson(json);
    }).toList();
    List<LatLng> _latLang =
        _steps.map((Step step) => step.startLatLng).toList();
    return _latLang;
  }

  Future<String> getAddressName(LatLng location, String apiKey) async {
    try {
      var endPoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&language=${setting.value.mobileLanguage.value}&key=${setting.value.googleMapsKey}';
      final response = await http.get(endPoint,
          headers: await LocationUtils.getAppHeaders());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if ((data['results'] as List).length > 0)
          return data['results'][0]['formatted_address'];
      } else
        throw Exception(response.body);
      return null;
    } catch (e, s) {
      CrashlyticsService.recordNonFatalError(e, s);
      return null;
    }
  }

  Future<DistanceMatrix> getDistanceMatrix(
      LatLng origin, LatLng destination) async {
    try {
      var endPoint =
          '$DISTANCE_MATRIX_API?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=${setting.value.googleMapsKey}';
      log(endPoint);
      var response = await http.get(endPoint,
          headers: await LocationUtils.getAppHeaders());
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var data = responseBody["rows"][0]["elements"] as List;
        return DistanceMatrix.fromJson(data.first);
      } else {
        throw Exception('Failed to calculate distance');
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return null;
    }
  }

  Future<List<DistanceMatrix>> getMultiDestinationsDistanceMatrix(
      LatLng origin, List<LatLng> destinations) async {
    try {
      String _desParams = "";
      destinations.forEach((element) {
        if (_desParams.isEmpty)
          _desParams += "${element.latitude},${element.longitude}";
        else
          _desParams += "|${element.latitude},${element.longitude}";
      });
      var endPoint =
          '$DISTANCE_MATRIX_API?origins=${origin.latitude},${origin.longitude}&destinations=$_desParams&key=${setting.value.googleMapsKey}';
      log(endPoint);
      var response = await http.get(endPoint,
          headers: await LocationUtils.getAppHeaders());
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var data = responseBody["rows"][0]["elements"] as List;
        return List<DistanceMatrix>.from(
            data?.map((x) => DistanceMatrix.fromJson(x)));
      } else {
        throw Exception('Failed to calculate distance');
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      return null;
    }
  }
}
