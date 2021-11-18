import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/vdialog.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog = new Vdialog();

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update(User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
      setState(() {});
      vdialog.pop(context,S.of(context).profile_settings_updated_successfully);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(),
      // ));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      vdialog.pop(context,S.of(context).payment_settings_updated_successfully);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(),
      // ));
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
