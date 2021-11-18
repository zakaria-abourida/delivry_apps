import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  /* GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: ['profile', 'email', 'phone']); */

  Timer timer;
  var provider = {};

  @override
  void initState() {
    super.initState();

    /*   _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) {
        provider.clear();
        provider = {
          "name": account.displayName,
          "email": account.email,
          "id": account.id,
          "picture": account.photoUrl,
          "provider_name": "google"
        };

        if (provider['id'] != null) {
          _con.providerRegister(provider, provider['provider_token'], "google");
        }
      }
    }); */
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  var userName;
  var password;
  bool visible = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: Text(''),
        // IconButton(
        //     icon: Icon(Icons.arrow_back_ios_rounded),
        //     color: Constants.primaryColor,
        //     // Within the SecondRoute widget
        //     onPressed: () {
        //       //Navigator.pop(context);
        //     }),
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
        child: Form(
          key: _con.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/img/icon-moto-scren-2.png',
                        fit: BoxFit.fitHeight,
                        height: 150,
                      ),
                    ),
                  ],
                ),
              ),
              /* SizedBox(height: 90),

              SignInButtonBuilder(
                backgroundColor: Colors.black,
                icon: FontAwesomeIcons.apple,
                padding: EdgeInsets.zero,
                width: 240,
                text: "Connexion avec Apple",
                onPressed: () => _con.appleSignIn(),
              ),

              SignInButtonBuilder(
                backgroundColor: Colors.blue[900],
                icon: FontAwesomeIcons.facebook,
                padding: EdgeInsets.zero,
                width: 240,
                text: "Connexion avec Facebook",
                onPressed: () {
                  _con.facebookSignIn();
                },
              ),

              SignInButtonBuilder(
                backgroundColor: Colors.blue,
                icon: FontAwesomeIcons.google,
                padding: EdgeInsets.zero,
                width: 240,
                text: "Connexion avec Google",
                onPressed: _handleSignIn,
              ), */
              SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "S'identifier",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // SignInButtonBuilder(
              //   backgroundColor: Colors.black,
              //   icon: FontAwesomeIcons.apple,
              //   padding: EdgeInsets.zero,
              //   width: 240,
              //   text: "Connexion avec Apple",
              //   onPressed: () => _con.appleSignIn(),
              // ),
              // SignInButtonBuilder(
              //   backgroundColor: Colors.blue[900],
              //   icon: FontAwesomeIcons.facebook,
              //   padding: EdgeInsets.zero,
              //   width: 240,
              //   text: "Connexion avec Facebook",
              //   onPressed: () {
              //     _con.facebookSignIn();
              //   },
              // ),

              // SignInButtonBuilder(
              //   backgroundColor: Colors.blue,
              //   icon: FontAwesomeIcons.google,
              //   padding: EdgeInsets.zero,
              //   width: 240,
              //   text: "Connexion avec Google",
              //   onPressed: _handleSignIn,
              // ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  // controller: TextEditingController(
                  //   text: ''//"omard@gmail.com"
                  // ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (input) => _con.user.email = input,
                  validator: (input) => !input.contains('@')
                      ? S.of(context).should_be_a_valid_email
                      : null,
                  decoration: InputDecoration(
                    labelText: S.of(context).email,
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'exemple@gmail.com',
                    hintStyle: TextStyle(
                        color: Theme.of(context).focusColor.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.mail_outline,
                        color: Theme.of(context).accentColor),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
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
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    contentPadding: EdgeInsets.all(12),
                    hintText: '••••••••••••',
                    hintStyle: TextStyle(
                        color: Theme.of(context).focusColor.withOpacity(0.7)),
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
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.2))),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      height: 37,
                      minWidth: 280,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Constants.primaryColor,
                      textColor: Colors.white,
                      onPressed: () => _con.login(),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20),
              //Text(
              //  'Se connecter avec',
              //  style: TextStyle(
              //    color: Colors.black,
              //    decoration: TextDecoration.underline,
              //    fontWeight: FontWeight.w500,
              //  ),
              //),
              // SizedBox(
              //   height: 20,
              // ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/SignUp');
                },
                child: Text(
                  'Créer un compte !',
                  style: TextStyle(
                    color: Constants.primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Text(
              //   'Mot De passe oublié ?',
              //   style: TextStyle(
              //     color: Constants.primaryColor,
              //     decoration: TextDecoration.underline,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              SizedBox(
                height: 16,
              ),
              /*  GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/Home');
                },
                child: Text(
                  "Continuer en tant qu'invité",
                  style: TextStyle(
                    color: Constants.primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),  */

              //SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  /*  Future<void> _handleSignIn() async {
    try {
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.disconnect();
      }
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  } */
}
