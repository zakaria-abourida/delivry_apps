import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../controllers/courier_adresses_controller.dart';
import '../../elements/CircularLoadingWidget.dart';
import '../../elements/CourierAddressDialog.dart';
import '../../elements/DeliveryAddressDialog.dart';
import '../../elements/DeliveryAddressesItemWidget.dart';
import '../../helpers/vdialog.dart';
import '../../models/address.dart';
import '../../models/payment_method.dart';
import '../../models/route_argument.dart';
import '../../repository/settings_repository.dart';

class CourierAddresses extends StatefulWidget {
  final RouteArgument routeArgument;
  CourierAddresses({Key key, this.routeArgument}) : super(key: key);

  @override
  _CourierAddressesState createState() => _CourierAddressesState();
}

class _CourierAddressesState extends StateMVC<CourierAddresses> {
  CourierAddressesController _con;
  PaymentMethodList list;
  Address defaultAddress;
  Vdialog vdialog = new Vdialog();

  _CourierAddressesState() : super(CourierAddressesController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList(context);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: Image.asset(
          'assets/img/logo.png',
          fit: BoxFit.fitHeight,
          height: 130,
          color: Theme.of(context).accentColor,
        ),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FlatButton(
          padding: EdgeInsets.symmetric(vertical: 14),
          minWidth: MediaQuery.of(context).size.width - 40,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 5),
            child: Text(
                (_con.addresses.length < 8)
                    ? "Définir l'adresse sur la carte"
                    : "Nombre maximum atteint",
                style: TextStyle(
                  color: (_con.addresses.length < 8)
                      ? Theme.of(context).accentColor
                      : Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                )),
          ),
          shape: StadiumBorder(),
          color: Colors.transparent,
          onPressed: () async {
            if (_con.addresses.length < 8) {
              LocationResult result = await showLocationPicker(
                context,
                setting.value.googleMapsKey,
                initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0,
                    deliveryAddress.value?.longitude ?? 0),
                automaticallyAnimateToCurrentLocation: true,
                mapStylePath: 'assets/json/mapStyle.json',
                myLocationButtonEnabled: true,
                resultCardAlignment: Alignment.bottomCenter,
              );
              if (result != null) {
                Address _address = new Address.fromJSON({
                  'address': result.address,
                  'latitude': result.latLng.latitude,
                  'longitude': result.latLng.longitude,
                });

                CourierAddressDialog(
                  context: context,
                  address: _address,
                  onChanged: (Address _address) {
                    _con.addAddress(_address, isCourier: true);
                  },
                );

                print("result = $result");
              }

              //setState(() => _pickedLocation = result);
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        FlatButton(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 40),
          child: new Text("Confirmer l'adresse",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          shape: StadiumBorder(),
          color: Theme.of(context).accentColor,
          onPressed: () {
            _con
                .updateAddress(defaultAddress)
                .whenComplete(() => Navigator.of(context).pop());
          },
        ),
      ]),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).accentColor,
        onRefresh: _con.refreshAddresses,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Définir l'adresse",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  )
                ],
              ),
              _con.addresses.isEmpty
                  ? CircularLoadingWidget(height: 250)
                  : ListView.separated(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.addresses.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Color(0xFFECEFF1),
                          height: 20,
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return DeliveryAddressesItemWidget(
                          address: _con.addresses.elementAt(index),
                          onPressed: (Address _address) {
                            log("onPressed address : ${_address.toString()}");
                            if (_address.id != null) {
                              if (_address.description == null) {
                                vdialog
                                    .pop(context,
                                        "La description de l'adresse est obligatoire")
                                    .whenComplete(() {
                                  DeliveryAddressDialog(
                                    context: context,
                                    address: _address,
                                    onChanged: (Address _address) {
                                      _con.updateAddress(_address);
                                    },
                                  );
                                });
                              } else {
                                _address.isDefault = true;
                                _con.updateAddress(_address).whenComplete(() {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          },
                          onRightPress: (Address _address) {
                            log("onRightPress address : ${_address.toString()}");
                            _con.addresses.forEach((address) {
                              address.isDefault = false;
                              if (address.id == _address.id) {
                                _address.isDefault = true;
                                defaultAddress = _address;
                              }
                              setState(() {});
                            });
                          },
                          onDismissed: (Address _address) {
                            _con.removeDeliveryAddress(_address);
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
