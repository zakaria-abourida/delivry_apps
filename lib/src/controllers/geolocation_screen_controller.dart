import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class GeolocationScreenController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  GeolocationScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    super.initState();    
  }
  
  Future getCurrentLocation() async {
    String latitudeData = "";
    String longtitudeData = "";
    bool getLoca = false;
    
    setState(() {
      getLoca = true;
    }); 

    final geopostion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData = '${geopostion.latitude}';
      longtitudeData = '${geopostion.longitude}';

      print(latitudeData + '   ' + longtitudeData);

      getLoca = false;
    });
  }

}
