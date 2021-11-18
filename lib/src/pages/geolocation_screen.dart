import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../src/pages/pre_auth_screen.dart';

class GeolocationScreen extends StatefulWidget {
  GeolocationScreen({Key key}) : super(key: key);

  @override
  GeolocationScreenState createState() => GeolocationScreenState();
}

class GeolocationScreenState extends State<GeolocationScreen> {
  DateTime currentBackPressTime;
  String latitudeData = "";
  String longtitudeData = "";

  bool getLoca = false;

  getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      getLoca = true;
    });

    final geopostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    prefs.setString('delivery_address', geopostion.toString());
    setState(() {
      latitudeData = '${geopostion.latitude}';
      longtitudeData = '${geopostion.longitude}';

      getLoca = false;
    });
  }

  void getNextPage() async {
    await SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('delivery_address')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/Preauth');
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   centerTitle: true,
        //   title: Image.asset(
        //     'assets/img/logo.png',
        //     fit: BoxFit.fitHeight,
        //     height: 130,
        //   ),
        //   elevation: 0,
        //    actions: <Widget>[
        //      new IconButton(
        //        icon: new Icon(Icons.arrow_back),
        //       onPressed: () => Navigator.of(context).pop(null),
        //      ),
        //    ],
        // ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image.asset(
                  'assets/img/logo.png',
                  fit: BoxFit.fitHeight,
                  height: 130,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Stack(
                  children: [
                    Container(
                      height: 350,
                      color: Constants.primaryColor,
                      child: Image.asset(
                        'assets/img/Capture.PNG',
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 100,
                      child: Container(
                        child: Image.asset(
                          'assets/img/icons-localisation-2-.png',
                          height: 60,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 200,
                      right: 100,
                      child: Container(
                        child: Image.asset(
                          'assets/img/icons-localisation-2-.png',
                          height: 60,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 200,
                      right: 100,
                      child: Container(
                        child: Image.asset(
                          'assets/img/icons-localisation-.png',
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Me localiser',
                        style: TextStyle(
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 30.0, left: 30.0, top: 5),
                      child: Text(
                        'Je partage ma position pour trouver facilement',
                        style: TextStyle(
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 30.0, left: 30.0, top: 0, bottom: 30),
                      child: Text(
                        'les lieux  et les services à proximité',
                        style: TextStyle(
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ),
                    FlatButton(
                      height: 37,
                      minWidth: 280,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: getLoca == false
                          ? Text(
                              'ACTIVER MA LOCALISATION',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                      color: Constants.primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        await getCurrentLocation();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreAuthScreen()));
                      },
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreAuthScreen()));
                      },
                      height: 37,
                      minWidth: 280,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'PLUS TARD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Constants.primaryColor,
                        ),
                      ),
                      color: Colors.grey[200],
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
          return Future.value(false);
        }
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(true);
      },
    );
  }
}
