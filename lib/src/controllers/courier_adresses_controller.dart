import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class CourierAddressesController extends ControllerMVC with ChangeNotifier {
  List<model.Address> addresses = <model.Address>[];
  model.Address current_address;
  GlobalKey<ScaffoldState> scaffoldKey;
  Vdialog vdialog;
  Cart cart;

  CourierAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    vdialog = new Vdialog();
    listenForAddresses();
  }

  void listenForAddresses({String message}) async {
    final Stream<model.Address> stream =
        await userRepo.getAddresses(isCourier: true);
    stream.listen((model.Address _address) {
      if (_address.isDefault) settingRepo.deliveryAddress.value = _address;
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        vdialog.pop(context, message);
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(message: S.of(context).addresses_refreshed_successfuly);
  }

  Future<void> changeDeliveryAddress(model.Address _address) async {
    updateAddress(_address);

    await settingRepo.changeCurrentLocation(_address).then((_address) {
      settingRepo.deliveryAddress.value = _address;
      settingRepo.deliveryAddress.notifyListeners();
    });

    print('changeDeliveryAddress : ' +
        settingRepo.deliveryAddress.value.toMap().toString());
    setState(() {});
  }

  Future<void> changeDeliveryAddressToCurrentLocation() async {
    settingRepo.deliveryAddress.value.isDefault = false;
    updateAddress(settingRepo.deliveryAddress.value);
    model.Address _address = await settingRepo.setCurrentLocation();
    _address.isDefault = true;

    //updateAddress(_address);
    await settingRepo.changeCurrentLocation(_address).then((_address) {
      settingRepo.deliveryAddress.value = _address;
      settingRepo.deliveryAddress.notifyListeners();
    });

    print('changeDeliveryAddressToCurrentLocation : ' +
        settingRepo.deliveryAddress.value.toMap().toString());
    setState(() {});
  }

  void addAddress(model.Address address, {isCourier = false}) {
    userRepo.addAddress(address, isCourier: isCourier).then((value) {
      setState(() {
        this.addresses.insert(0, value);
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).new_address_added_successfully),
      ));
    });
  }

  void chooseDeliveryAddress(model.Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
    setState(() {});
  }

  Future<void> updateAddress(model.Address address) async {
    await userRepo.updateAddress(address).then((value) {
      addresses.clear();
      listenForAddresses();
      setState(() {});
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      vdialog.pop(context, S.of(context).delivery_address_removed_successfully);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(),
      // ));
    });
  }
}
