import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';

class SignUpWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  SignUpWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  Timer timer;
  var provider = {};
  UserController _con;
  TextEditingController nameInputController = new TextEditingController();
  TextEditingController emailInputController = new TextEditingController();
  TextEditingController phoneInputController = new TextEditingController();
  TextEditingController idInputController = new TextEditingController();

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    if (widget.routeArgument != null) {
      nameInputController.text = widget.routeArgument.param;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final key = GlobalKey<FormState>();

  bool create = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: Constants.primaryColor,
            // Within the SecondRoute widget
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/img/logo.png',
          fit: BoxFit.fitHeight,
          height: 130,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30),
            child: Form(
              key: _con.loginFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    height: 120,
                    width: 100,
                    child: Image.asset(
                      'assets/img/icon-profil-scren-3.png',
                      fit: BoxFit.fitHeight,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Créer un compte',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      height: 50,
                      // color: Colors.grey[100],
                      child: TextFormField(
                        controller: nameInputController,
                        keyboardType: TextInputType.name,
                        onSaved: (input) => _con.user.name = input,
                        validator: (input) => input.length < 3
                            ? S.of(context).should_be_more_than_3_letters
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).full_name,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Nom et Prénom',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      height: 50,
                      // color: Colors.grey[100],
                      child: TextFormField(
                        controller: emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con.user.email = input,
                        validator: (input) => !input.contains('@')
                            ? S.of(context).should_be_a_valid_email
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'exemple@gmail.com',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.mail_outline,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      height: 50,
                      // color: Colors.grey[100],
                      child: TextFormField(
                        controller: phoneInputController,
                        keyboardType: TextInputType.phone,
                        onSaved: (input) => _con.user.phone = input,
                        decoration: InputDecoration(
                          labelText: S.of(context).phone,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Téléphone',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.phone,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      height: 50,
                      // color: Colors.grey[100],
                      child: TextFormField(
                        // controller: TextEditingController(
                        //   text: ""//"1234567890"
                        // ),
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _con.user.password = input,
                        validator: (input) => input.length < 3
                            ? S.of(context).should_be_more_than_3_characters
                            : null,
                        obscureText: _con.hidePassword,
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '••••••••••••',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con.hidePassword = !_con.hidePassword;
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(_con.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Container(
                  //         height: 40,
                  //         child: TextFormField(
                  //             keyboardType: TextInputType.phone,
                  //             onSaved: (input) => _con.user.phone = input,
                  //             decoration: InputDecoration(
                  //                 labelText: /*S.of(context).phone*/ "Téléphone",
                  //                 border: OutlineInputBorder(),
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderSide: BorderSide(
                  //                     color: Constants.primaryColor,
                  //                   ),
                  //                 ),
                  //                 enabledBorder: OutlineInputBorder(
                  //                     borderSide: BorderSide(
                  //                   color: Constants.primaryColor,
                  //                 )))))),
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Container(
                  //         height: 40,
                  //         child: TextFormField(
                  //             controller: emailInputController,
                  //             keyboardType: TextInputType.emailAddress,
                  //             onSaved: (input) => _con.user.email = input,
                  //             validator: (input) => !input.contains('@')
                  //                 ? S.of(context).should_be_a_valid_email
                  //                 : null,
                  //             decoration: InputDecoration(
                  //                 labelText: S.of(context).email,
                  //                 border: OutlineInputBorder(),
                  //                 focusedBorder: OutlineInputBorder(
                  //                   borderSide: BorderSide(
                  //                     color: Constants.primaryColor,
                  //                   ),
                  //                 ),
                  //                 enabledBorder: OutlineInputBorder(
                  //                     borderSide: BorderSide(
                  //                   color: Constants.primaryColor,
                  //                 )))))),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  FlatButton(
                    height: 37,
                    minWidth: 280,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: create == false
                        ? Text(
                            "ENREGISTRER",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                          ),
                    color: Constants.primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      _con.register();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
