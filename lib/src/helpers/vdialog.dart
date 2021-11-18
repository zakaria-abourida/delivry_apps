import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'package:food_delivery_app/src/models/setting.dart';

import '../../constant.dart';

class Vdialog {
  Future pop(context, message) async {
    return showDialog<bool>(
        context: context,
        child: new AlertDialog(content: new Text(message), actions: <Widget>[
          new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
          // new FlatButton(
          //     child: new Text("A"),
          //     onPressed: () {
          //       Navigator.of(context).pop(false);
          //     })
        ]));
  }

  Future popAskToCompleteProfile(context, message) async {
    return showDialog<bool>(
        context: context,
        child: new AlertDialog(content: new Text(message), actions: <Widget>[
          new FlatButton(
              child: new Text("Continuer"),
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pushNamed('/Settings');
              }),
        ]));
  }

  Future courierAlert(context, Setting setting) async {
    return showDialog<bool>(
        context: context,
        child: WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            backgroundColor: Colors.pink,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 100,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.delivery_dining,
                  size: 40,
                  color: Colors.white,
                ),
                Expanded(
                    child: Text(
                  "Le coursier est disponible entre " +
                      setting.coursierStartTime.replaceAll(':', 'h') +
                      "  et  " +
                      setting.coursierEndTime.replaceAll(':', 'h'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                )),
              ],
            ),
            actions: <Widget>[
              new RaisedButton(
                color: Colors.pink,
                child: new Text(
                  'fermer',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
  }

  Future popToSignUpManually(
      BuildContext context, String message, String username) async {
    return showDialog<bool>(
        context: context,
        child: new AlertDialog(content: new Text(message), actions: <Widget>[
          new FlatButton(
              child: new Text("Continuer"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/SignUp',
                    arguments: RouteArgument(param: username));
              }),
        ]));
  }

  succesOrderDialog(BuildContext context) {
    return showDialog<String>(
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushReplacementNamed('/Restaurants');
              return Future.value(true);
            },
            child: SizedBox.expand(
                child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Constants.primaryColor.withOpacity(1),
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/order_success.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: IconButton(
                      //     onPressed: () => Navigator.pop(context),
                      //     icon: Icon(
                      //       Icons.close,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 40),
                          child: new Text("Voir ma commande",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          shape: StadiumBorder(),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/Pages', arguments: 3);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 40),
                          child: new Text("Passer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          shape: StadiumBorder(),
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/Restaurants');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ))));
  }

  errorOrderDialog(BuildContext context) {
    return showDialog<String>(
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushReplacementNamed('/Restaurants');
              return Future.value(true);
            },
            child: SizedBox.expand(
                child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Constants.primaryColor.withOpacity(1),
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/icons-closed.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: IconButton(
                      //     onPressed: () => Navigator.pop(context),
                      //     icon: Icon(
                      //       Icons.close,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 40),
                          child: new Text("Réessayer",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          shape: StadiumBorder(),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/Restaurants');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ))));
  }

  Future popOrderError(context, message) async {
    return showDialog<bool>(
        context: context,
        child: new AlertDialog(content: new Text(message), actions: <Widget>[
          new FlatButton(
              child: new Text("Réessayer"),
              onPressed: () {
                Navigator.of(context).pushNamed('/Restaurants');
              }),
          // new FlatButton(
          //     child: new Text("A"),
          //     onPressed: () {
          //       Navigator.of(context).pop(false);
          //     })
        ]));
  }
}
