import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_delivery_app/src/services/crashlytics_service.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../helpers/vdialog.dart';
import '../models/user.dart' as userModel;
import '../pages/home.dart';
import '../repository/user_repository.dart' as user_repo;

class UserController extends ControllerMVC {
  userModel.User user = new userModel.User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;
  Vdialog vdialog = new Vdialog();

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void providerLogin(provider, token) async {
    //Overlay.of(context).insert(loader);
    user_repo.providerLogin(provider, token).then((value) {
      if (value != null && value.apiToken != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeWidget()));
      } else {
        vdialog.pop(context, S.of(context).wrong_email_or_password);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(S
        //       .of(context)
        //       .wrong_email_or_password),
        // ));
      }
    }).catchError((e) {
      //loader.remove();
      if (e.message)
        vdialog.pop(context, e.message);
      else
        vdialog.pop(context, e.toString());
      //vdialog.pop(context, S.of(context).this_account_not_exist);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S
      //       .of(context)
      //       .this_account_not_exist),
      // ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      user_repo.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeWidget()));
        } else
          throw Exception();
      }).catchError((e, s) {
        log(e.toString());
        loader.remove();
        vdialog.pop(context, S.of(context).wrong_email_or_password);
      }).whenComplete(() {        
        Helper.hideLoader(loader);
      });
    }
  }

  facebookSignUp() async {
    try {
      if (await FacebookAuth.instance.getUserData() != null) {
        FacebookAuth.instance.logOut();
      }

      AccessToken accessToken = await FacebookAuth.instance.login();

      //print(accessToken.toJson());
      // get the user data
      var provider = await FacebookAuth.instance.getUserData();

      return [provider, accessToken.token];
    } on FacebookAuthException catch (e) {
      print(e.message);
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          return ("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          return ("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          return ("login failed");
          break;
      }
    }
  }

  facebookSignIn() async {
    FocusScope.of(context).unfocus();
    this.facebookSignUp().then((result) async {
      // Overlay.of(context).insert(loader);
      /* result[0]["email"] == null */
      if (result[0]["email"] == null) {
        vdialog.popToSignUpManually(
            context,
            "Ce compte facebook ne contient pas d'email, Veuillez fournir vos informations manuellement !",
            result[0]["name"]
            );
      } else {
        providerRegister(result[0], result[1], "facebook");
      }
    });
  }

  void register() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      user_repo.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Home');
        } else {



          vdialog.pop(context, S.of(context).wrong_email_or_password);

          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text(S
          //       .of(context)
          //       .wrong_email_or_password),
          // ));
        }
      }).catchError((e) {
        log(e.toString());
        loader?.remove();
        if (e.message)
          vdialog.pop(context, e.message);
        else
          vdialog.pop(context, e.toString());
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(e.toString()),
        // ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void providerRegister(provider, token, name) async {
    print("line 1");
    user_repo.providerRegister(provider, token, name).then((value) {
      print("line 2");
      if (value != null && value.apiToken != null) {
        print("line 3");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeWidget())
            );
// providerLogin(provider, token);
      } else {
        print("line 4");
        vdialog.pop(context, S.of(context).wrong_email_or_password);

// scaffoldKey?.currentState?.showSnackBar(SnackBar(
// content: Text(S
// .of(context)
// .wrong_email_or_password),
// ));
      }
    }).catchError((e) {
      print("line 5");
      log(e.message);
//loader?.remove();
      if (e.message)
        vdialog.pop(context, e.message);
      else
        vdialog.pop(context, e.toString());
// scaffoldKey?.currentState?.showSnackBar(SnackBar(
// content: Text(e.toString())
// //Text(S.of(context).this_email_account_exists+". Veuillez Utilisé votre mot de passe pour vous connecter"),
// ));
//providerLogin(result[0],result[1]);
    }).whenComplete(() {
      print("line 6");
      Helper.hideLoader(loader);
    });
    print("line 7");
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      user_repo.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          vdialog.pop(context, S.of(context).error_verify_email_settings);
          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text(),
          // ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  /*Future<void> appleSignIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential.email);
    print(credential.givenName);
    if (credential.email == null) {
      vdialog.pop(context,
          "Merci de s'inscrire manuellement, vos informations sont invalides ...");
    }

    providerRegister(credential, credential.identityToken, "apple");
  }*/

  Future<void> appleSignIn() async {
    AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    String em = await FlutterSecureStorage().read(key: "email");
    String name = await FlutterSecureStorage().read(key: "name");
    String id = await FlutterSecureStorage().read(key: "userId");

    if (em == null && credential.email == null) {
      vdialog.pop(context,
          "Pour certaines raisons, nous n'avons pas pu recevoir votre e-mail,Pouvez-vous essayer d'utiliser un autre compte Apple ou essayer de vous déconnecter de votre icould et de vous reconnecter ...");
    }
//       vdialog.pop(context,
//           "Pour certaines raisons, nous n'avons pas pu recevoir votre e-mail,
// Pouvez-vous essayer d'utiliser un autre compte Apple ou essayer de vous déconnecter de votre icould et de vous reconnecter ...");

    vdialog.pop(context, "Pour certaines");
    if (em == null && credential.email != null) {
      await FlutterSecureStorage()
          .write(key: "userId", value: credential.identityToken);
      await FlutterSecureStorage().write(key: "email", value: credential.email);
      await FlutterSecureStorage().write(
          key: "name",
          value: credential.familyName + " " + credential.givenName);
    }
    if (em != null && credential.email == null) {
      var data = {
        'provider_name': "apple",
        'provider_token': id,
        'name': name,
        'email': em,
        'password': "000000000000"
// 'picture': provider.picture.data.url,
      };
      providerRegister(data, credential.identityToken, "apple2");
    } else
      providerRegister(credential, credential.identityToken, "apple");
  }
}
