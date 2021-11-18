import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/EmptyAddressWidget.dart';
import 'package:food_delivery_app/src/elements/EmptyCartWidget.dart';
import 'package:food_delivery_app/src/elements/EmptyMessagesWidget.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/delivery_addresses_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class DeliveryAddressesWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  DeliveryAddressesWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryAddressesWidgetState createState() =>
      _DeliveryAddressesWidgetState();
}

class _DeliveryAddressesWidgetState extends StateMVC<DeliveryAddressesWidget> {
  DeliveryAddressesController _con;
  PaymentMethodList list;
  Address defaultAddress;
  Vdialog vdialog = new Vdialog();

  _DeliveryAddressesWidgetState() : super(DeliveryAddressesController()) {
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
        // Text(
        //   S.of(context).delivery_addresses,
        //   style: Theme.of(context)
        //       .textTheme
        //       .headline6
        //       .merge(TextStyle(letterSpacing: 1.3)),
        // ),
        // actions: <Widget>[
        //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        // ],
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
                    fontWeight: FontWeight.w600)),
          ),
          shape: StadiumBorder(),
          color: Colors.transparent,
          onPressed: () async {
            if (_con.addresses.length < 8) {
              log('GOOGLE MAP KEY' + setting.value.googleMapsKey);
              LocationResult result = await showLocationPicker(
                  context, setting.value.googleMapsKey,
                  initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0,
                      deliveryAddress.value?.longitude ?? 0),
                  automaticallyAnimateToCurrentLocation: true,
                  //mapStylePath: 'assets/mapStyle.json',
                  myLocationButtonEnabled: true,
                  resultCardAlignment: Alignment.bottomCenter,
                  countries: ['MA'],
                  language: 'fr');

              Address _address = new Address.fromJSON({
                'address': result.address,
                'latitude': result.latLng.latitude,
                'longitude': result.latLng.longitude,
              });

              DeliveryAddressDialog(
                context: context,
                address: _address,
                onChanged: (Address _address) {
                  _con.addAddress(_address);
                },
              );

              print("result = $result");
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
        // FloatingActionButton(
        //     onPressed: () async {
        //       LocationResult result = await showLocationPicker(
        //         context,
        //         setting.value.googleMapsKey,
        //         initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0,
        //             deliveryAddress.value?.longitude ?? 0),
        //         //automaticallyAnimateToCurrentLocation: true,
        //         //mapStylePath: 'assets/mapStyle.json',
        //         myLocationButtonEnabled: true,
        //         resultCardAlignment: Alignment.bottomCenter,
        //       );

        //       _con.addAddress(new Address.fromJSON({
        //         'address': result.address,
        //         'latitude': result.latLng.latitude,
        //         'longitude': result.latLng.longitude,
        //       }));

        //       print("result = $result");
        //       //setState(() => _pickedLocation = result);
        //     },
        //     backgroundColor: Theme.of(context).accentColor,
        //     child: Icon(
        //       Icons.add,
        //       color: Theme.of(context).primaryColor,
        //     )),
      ]),
      // : SizedBox(height: 0),
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
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text("Définir l'adresse",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  )
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              //   child: ListTile(
              //     contentPadding: EdgeInsets.symmetric(vertical: 0),
              //     leading: Icon(
              //       Icons.map,
              //       color: Theme.of(context).hintColor,
              //     ),
              //     title: Text(
              //       S.of(context).delivery_addresses,
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //       style: Theme.of(context).textTheme.headline4,
              //     ),
              //     subtitle: Text(
              //       S.of(context).long_press_to_edit_item_swipe_item_to_delete_it,
              //       maxLines: 2,
              //       overflow: TextOverflow.ellipsis,
              //       style: Theme.of(context).textTheme.caption,
              //     ),
              //   ),
              // ),

              _con.addresses.isEmpty
                  ? EmptyAddressWidget()
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
                            // _con.addAddress(_con.deliveryAddress);
                            // addressIsSet = ! addressIsSet;
                            // // if (_con.deliveryAddress.id == null ||
                            // //     _con.deliveryAddress.id == 'null') {
                            // //   DeliveryAddressDialog(
                            // //     context: context,
                            // //     address: _address,
                            // //     onChanged: (Address _address) {
                            // //       _con.addAddress(_address);
                            // //     },
                            // //   );
                            // // } else {
                            // //   _con.toggleDelivery();
                            // // }
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

// DeliveryAddressDialog(
//   context: context,
//   address: _address,
//   onChanged: (Address _address) {
//      _con.updateAddress(_address);
//   },
// );
