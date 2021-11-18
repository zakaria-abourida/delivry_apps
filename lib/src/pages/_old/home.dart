import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant.dart';
import '../../../generated/l10n.dart';
import '../../controllers/delivery_addresses_controller.dart';
import '../../elements/DrawerWidget.dart';
import '../../elements/SearchBarWidget.dart';
import '../../models/address.dart';
import '../../widget/BottomBar.dart';
import '../../widget/CustomDropdown.dart';

class HomeWidget extends StatefulWidget {
    final GlobalKey<ScaffoldState> parentScaffoldKey;

    HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}
class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}
class _HomeWidgetState extends StateMVC<HomeWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool version=true;
  DateTime currentBackPressTime;
  DeliveryAddressesController _con;
  Address selectedAddress;
  // List<Address> addresses = <Address>[
  //   const Address('Localisaton actuelle',Icon(Icons.send,color:  Constants.primaryColor)),
  //   const Address('Imm Tour A 5eme étage bel',Icon(Icons.pin_drop,color:  Constants.primaryColor)),
  // ];
  

  @override
  void initState() {
    // TODO: implement initState
    try {
      if(version) {
        versionCheck(context);
        version=false;
      }
    } catch (e) {
      print(e);
    }
    super.initState();
    
  }

  versionCheck(context) async {
    //Get Current installed version of app
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
    String iosV=prefs.get('iosVersion');
    String androidV=prefs.get('androidVersion');
    double androidVersion=double.parse(androidV.trim().replaceAll(".", ""));
    double iosVersion=double.parse(iosV.trim().replaceAll(".", ""));

    double newVersion = Platform.isIOS
        ? iosVersion:androidVersion;
    print(newVersion);
    print(currentVersion);
    //Get Latest version info from firebase config
    final  remoteConfig=null ;

    try {
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on Exception catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
  }
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL("https://apps.apple.com/us/app/webili/id1546784996"),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL("https://play.google.com/store/apps/details?id=com.webiliapp.food_delivery_app"),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
  _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  _HomeWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    var tool = MediaQuery.of(context).size.height - 250;
    return WillPopScope(
      child:Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white,
      //   elevation: 0,
      //   child: new Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(
      //           Icons.favorite,
      //         ),
      //         onPressed: () {
      //            Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (context) => FavoritesWidget()
      //                       )
      //               );
      //          },
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
      //         child: Container(
      //           child: Image.asset(
      //             "assets/img/icon-support-scren-4.png",
      //             height: 55,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: BottomBarWebili(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
            color: Constants.primaryColor,
            icon: Icon(Icons.person),
            iconSize: 35,
          )
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: Constants.primaryColor,
            // Within the SecondRoute widget
            onPressed: () {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
                return Future.value(false);
              }
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return Future.value(true);
            }),
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        title: Image.asset(
          'assets/img/logo.png',
          fit: BoxFit.fitHeight,
          height: 130,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
            child: 
            Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Column(
                    children: [
                      //Dropdown
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, right: 20.0),
                        child:CustomDropdown(addresses:_con.addresses, refreshAddresses: _con.refreshAddresses)
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top:5.0, left:15, right:15),
                        child:  Container(                          
                          child:SearchBarWidget() 
                        ),                  
                      ),
                      Container(
                        color: Colors.white,
                        height: tool,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: tool,
                                width: MediaQuery.of(context).size.width / 2,
                                color: Colors.transparent,
                                child: Image.asset(
                                  'assets/img/icons-cote-.png',
                                  height: tool,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 20,
                            //   left: 30,
                            //   child: Container(
                            //     height: 140,
                            //     width: 130,
                            //     color: Colors.transparent,
                            //     child:
                            //     GestureDetector(
                            //         onTap: () {
                            //           // openDialogDate(context, "14/03/2021");
                            //         },
                            //         child:Image.asset(
                            //           'assets/img/icon-booking.png',
                            //           height: 150,
                            //         )
                            //       ), 
                                  
                                  
                            //   ),
                            // ),
                            
                            Positioned(
                                                  
                              top: 150,
                              left: 30,
                              child: Container(                      
                                height: 130,
                                width: 130,
                                color: Colors.transparent,                      
                                child: 
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/Restaurants');
                                    // Navigator.of(context).pushReplacementNamed('/Restaurants');
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => RestaurantListWidget(parentScaffoldKey: widget.parentScaffoldKey)
                                    //   )
                                    // );
                                },
                                child:Image.asset(
                                  'assets/img/icon-livraison-.png',
                                  height: 150,
                                )
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 350,
                            //   left: 140,
                            //   child: Container(
                            //       height: 130,
                            //       width: 130,
                            //       color: Colors.transparent,
                            //       child: 
                            //       GestureDetector(
                            //         onTap: () {
                            //           // openDialogDate(context, "14/02/2021");
                            //           //openDialogOrderSuccess(context);
                            //         },
                            //         child:Image.asset(
                            //           'assets/img/icon-abraca.png',
                            //           height: 150,
                            //         )
                            //       ),
                            //     ),                        
                            // ),
                        
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            )
            
    ),
     onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
          return Future.value(false);
        }
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');  
        return Future.value(true);
      },
    
    );
  }

  static Future<void> openDialogDate(BuildContext context, String date) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Constants.primaryColor.withOpacity(1),
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Image.asset("assets/img/icons-star.png",
                              height: 100, color: Colors.white),

                          Text(date,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27)),
                          SizedBox(
                            height: 100,
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_rounded,
                          //   color: Colors.white,
                          //   size: 80,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        })) {
    }
  }

  static Future<void> openDialogNote(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Constants.primaryColor.withOpacity(1),
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 220,
                            child: Image.asset(
                              'assets/img/icons-popapp.png',
                              fit: BoxFit.fitHeight,
                              height: 250,
                            ),
                          ),
                          Container(
                            child: Text(
                              'NOTER LE LIVREUR ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle_outlined,
                                          color: Colors.white, size: 40),
                                      Text('  Nom & Prénom',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(height: 40),
                          Container(
                            child: Text(
                              'NOTER RESTAURANT ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle_outlined,
                                          color: Colors.white, size: 40),
                                      Text('  Nom & Prénom',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.verified_user_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Text('webiliapp.com',
                                style: TextStyle(fontSize: 13)),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        })) {
    }
  }

  static Future<void> openDialogPersonaliser(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.grey[300],
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 50),
                                child: Icon(Icons.close, color: Colors.black)),
                            Center(
                              child: Container(
                                  child: Image.asset("assets/img/logo.png",
                                      width: 100)),
                            ),
                          ],
                        ),
                        Text('Personnalisez votre sandwich',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Choisissez votre accompagnement*',
                                style: TextStyle(color: Colors.grey),
                              )),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('1 Seul article',
                                style: TextStyle(fontSize: 10))),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('* Obligatoire',
                                style: TextStyle(fontSize: 10))),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Frits',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: true,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Potates',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Salades',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Divider(color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Choisissez votre boisson*',
                                style: TextStyle(color: Colors.grey),
                              )),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('1 Seul article',
                                style: TextStyle(fontSize: 10))),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('* Obligatoire',
                                style: TextStyle(fontSize: 10))),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Coca',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: true,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sprite',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pepsi',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Eau minérale',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jus d'orange",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Radio(
                                value: false,
                                groupValue: true,
                                onChanged: (value) => {})
                          ],
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: () => {},
                            minWidth: double.infinity,
                            color: Constants.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                ),
                            child: Text(
                              'Terminer',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          );
        })) {
    }
  }

}
