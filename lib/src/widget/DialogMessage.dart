import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constant.dart';

class DialogMessage {
  final BuildContext context;

  DialogMessage(this.context);
  double val = 200;
  static Future<void> openDialog(BuildContext context) async {
    var height = MediaQuery.of(context).size.height - 200.0;

    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Constants.primaryColor.withOpacity(1),
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                child: Container(
                  height: height,
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
                          Container(
                            height: 220,
                            child: Image.asset(
                              'assets/img/icons-popapp.png',
                              fit: BoxFit.fitHeight,
                              height: 250,
                            ),
                          ),
                          Container(
                            child: Image.asset(
                              'assets/img/icons-verifie-.png',
                              fit: BoxFit.fitHeight,
                              height: 100,
                            ),
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_rounded,
                          //   color: Colors.white,
                          //   size: 80,
                          // ),
                          Text(
                            'Commande',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            'envoyée',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          )
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
}
