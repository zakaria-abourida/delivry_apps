import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:food_delivery_app/src/helpers/vdialog.dart';
import 'package:food_delivery_app/src/models/setting.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../constant.dart';
import '../../controllers/courier_order_controller.dart';
import '../../elements/CircularLoadingWidget.dart';
import '../../elements/CourierAddressDialog.dart';
import '../../elements/CourierBottomDetailsWidget.dart';
import '../../elements/CustomDropDown.dart';
import '../../elements/DeliveryAddressesItemWidgetCheckout.dart';
import '../../helpers/helper.dart';
import '../../models/address.dart';
import '../../repository/settings_repository.dart';
import '../../widget/AppBarWebili.dart';

class CourierOrderScreen extends StatefulWidget {
  @override
  _CourierOrderState createState() => _CourierOrderState();
}

class _CourierOrderState extends StateMVC<CourierOrderScreen> {
  CourierOrderController _con;
  bool isLoading = true;

  _CourierOrderState() : super(CourierOrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    initCourierService();
  }

  void initCourierService() {
    _con.listenForSetting().then((value) {
      if (value != null) {
        final result = _con.checkCourierAvailability(
            value.coursierStartTime, value.coursierEndTime);
        setState(() {
          _con.isCourierServiceOpen = result;
        });
        if (!result) {
          Vdialog().courierAlert(context, value);
        }
      } else {
        Future.delayed(Duration(seconds: 2)).then((_) => initCourierService());
      }
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> addNewAddress(
      {Address oldAddress, isCollectAddress = false}) async {
    LocationResult result = await showLocationPicker(
        context, setting.value.googleMapsKey,
        initialCenter: oldAddress != null
            ? LatLng(oldAddress?.latitude ?? 0, oldAddress?.longitude ?? 0)
            : LatLng(deliveryAddress.value?.latitude ?? 0,
                deliveryAddress.value?.longitude ?? 0),
        automaticallyAnimateToCurrentLocation: true,
        //mapStylePath: 'assets/json/mapStyle.json',
        myLocationButtonEnabled: true,
        resultCardAlignment: Alignment.bottomCenter,
        language: 'fr',
        countries: ['MA']);
    if (result != null) {
      final _address = new Address.fromJSON({
        'address': result.address,
        'latitude': result.latLng.latitude,
        'longitude': result.latLng.longitude,
      });
      showNewContactAddressAlert(_address, isCollectAddress);
    }
  }

  void showNewContactAddressAlert(Address address, bool isCollectAddress) {
    CourierAddressDialog(
      context: context,
      address: address,
      onChanged: (Address _address) {
        _con.addAddress(_address, isCollectAddress: isCollectAddress);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
          key: _con.scaffoldKey,
          bottomNavigationBar: isLoading || !_con.isCourierServiceOpen
              ? SizedBox()
              : CourierBottomDetailsWidget(
                  con: _con,
                  paymentStep: null,
                  //beforeCheckout: beforeCheckout,
                  route: null,
                  addressIsSet: true,
                  deliveryAddress: _con.deliveryAddress),
          appBar: AppBarWebili(
            bgColor: "grey",
            showActionIcon: false,
          ),
          backgroundColor: Colors.white,
          body: isLoading
              ? CircularLoadingWidget(height: ScreenUtil().screenHeight)
              : _con.isCourierServiceOpen
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: ListView(
                        primary: true,
                        children: <Widget>[
                          Center(
                              child: Text("Ma commande Abracadabra",
                                  style: Constants.courierTextStyle
                                      .copyWith(color: Colors.black87))),
                          SizedBox(height: 12.0),

                          //------------------------------------------------------------------
                          // Adresse de collecte
                          //------------------------------------------------------------------
                          Row(
                            children: [
                              Image(
                                width: 18,
                                image: AssetImage("assets/img/pin.png"),
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Adresse de collecte",
                                style: Constants.courierTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Divider(
                            color: Color(0xFFECEFF1),
                            height: 2,
                            thickness: 2,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              child: _con.collectAddress == null
                                  ? FlatButton(
                                      onPressed: () =>
                                          addNewAddress(isCollectAddress: true),
                                      disabledColor: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      color: Colors.transparent,
                                      shape: StadiumBorder(),
                                      child: Text('+ Ajouter une adresse',
                                          textAlign: TextAlign.start,
                                          style: Constants.courierPrimaryText))
                                  : DeliveryAddressesItemWidgetCheckout(
                                      isCourier: true,
                                      paymentMethod:
                                          null, //_con.getDeliveryMethod(),
                                      address: _con.collectAddress,
                                      selected: false,
                                      onPressed: (Address _address) =>
                                          addNewAddress(
                                              oldAddress: _address,
                                              isCollectAddress: true),
                                    )
                              //: NotDeliverableAddressesItemWidget()
                              ),

                          //------------------------------------------------------------------
                          // Adresse de livraison
                          //------------------------------------------------------------------
                          Row(
                            children: [
                              Image(
                                width: 18,
                                image: AssetImage("assets/img/pin.png"),
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Adresse de livraison",
                                style: Constants.courierTextStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Divider(
                            color: Color(0xFFECEFF1),
                            height: 2,
                            thickness: 2,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              child: _con.deliveryAddress == null
                                  ? SizedBox(
                                      child: FlatButton(
                                          onPressed: () => addNewAddress(),
                                          disabledColor: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          color: Colors.transparent,
                                          shape: StadiumBorder(),
                                          child: Text('+ Ajouter une adresse',
                                              style: Constants
                                                  .courierPrimaryText)),
                                    )
                                  : DeliveryAddressesItemWidgetCheckout(
                                      isCourier: true,
                                      paymentMethod:
                                          null, //_con.getDeliveryMethod(),
                                      address: _con.deliveryAddress,
                                      selected: false,
                                      onPressed: (Address _address) =>
                                          addNewAddress(oldAddress: _address),
                                    )
                              //: NotDeliverableAddressesItemWidget()
                              ),
                          //------------------------------------------------------------------
                          // Commentaires
                          //------------------------------------------------------------------

                          Row(
                            children: [
                              Image(
                                width: 18,
                                image: AssetImage("assets/img/VC.png"),
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12),
                              Text("Votre commande",
                                  style: Constants.courierTextStyle),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Divider(
                              color: Color(0xFFECEFF1),
                              height: 2,
                              thickness: 2),
                          Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            child: Card(
                              elevation: 0,
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _con.commentInputController,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade800),
                                  maxLines: 3,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration.collapsed(
                                      hintStyle: Constants.courierTextStyle
                                          .copyWith(
                                              fontFamily: 'GothamBoldBook',
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w300),
                                      hintText:
                                          "Que souhaitez-vous envoyer ou récupérer..."),
                                ),
                              ),
                            ),
                          ),

                          //SizedBox(height: 15),

                          //------------------------------------------------------------------
                          // heure de livraison
                          //------------------------------------------------------------------
                          Row(
                            children: [
                              Image(
                                width: 18,
                                image: AssetImage("assets/img/heur.png"),
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12),
                              Text("Heure de livraison",
                                  style: Constants.courierTextStyle),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Divider(
                            color: Color(0xFFECEFF1),
                            height: 2,
                            thickness: 2,
                          ),
                          _buildTimeDropDownList(),

                          //Options de paiement
                          Row(
                            children: [
                              Image(
                                width: 24,
                                image: AssetImage("assets/img/mp.png"),
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12),
                              Text("Mode de paiement",
                                  style: Constants.courierTextStyle),
                            ],
                          ),
                          SizedBox(height: 4),
                          Divider(
                            color: Color(0xFFECEFF1),
                            height: 2,
                            thickness: 2,
                          ),
                          ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _paymentMethodList().length,
                            //separatorBuilder: (context, index) => SizedBox(height: 4),
                            itemBuilder: (context, index) =>
                                _paymentMethodList()[index],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    )
                  : Container()),
    );
  }

  Widget _buildTimeDropDownList() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 6),
      child: CustomDropDown(
        errorText: "",
        hint: "",
        items: _con.deliveryTimeList
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        value: _con.deliveryTime,
        onChanged: (val) => _con.onChangedDeliveryTime(val),
      ),
    );
  }

  List<Widget> _paymentMethodList() => [
        GestureDetector(
          onTap: () => _con.onChangedSelectedPayment(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/img/cash.png',
                          ),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("Paiement à la livraison",
                      style: Constants.courierTextStyle.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'GothamBoldBook',
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Radio(
                value: 0,
                groupValue: _con.selectedPaymentMethod,
                onChanged: (val) => _con.onChangedSelectedPayment(val),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _con.onChangedSelectedPayment(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/img/mastercard.png',
                          ),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text("Paiement par carte",
                      style: Constants.courierTextStyle.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'GothamBoldBook',
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Radio(
                value: 1,
                groupValue: _con.selectedPaymentMethod,
                onChanged: (val) => _con.onChangedSelectedPayment(val),
              ),
            ],
          ),
        )
      ];
}
