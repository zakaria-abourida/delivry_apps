import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import '../../controllers/cart_controller.dart';
import '../../services/facebook_services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../generated/l10n.dart';
import '../../controllers/delivery_pickup_controller.dart';
import '../../elements/CartBottomDetailsWidget.dart';
import '../../elements/DeliveryAddressesItemWidgetCheckout.dart';
import '../../elements/PaymentMethodListItemWidget.dart';
import '../../elements/CircularLoadingWidget.dart';
import '../../elements/DrawerWidget.dart';
import '../../helpers/helper.dart';
import '../../models/address.dart';
import '../../models/cart.dart';
import '../../models/payment_method.dart';
import '../../models/route_argument.dart';
import '../../repository/restaurant_repository.dart' as resto_repo;
import '../../pages/delivery_addresses.dart';
import '../../pages/payzone_payment.dart';
import '../../helpers/vdialog.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;
  CartController _con_cart = new CartController();
  bool addressIsSet = false;
  PaymentMethodList list;
  Vdialog vdialog = new Vdialog();
  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  String route = null;
  void changeRoute(newRoute) {
    if (newRoute == "/Checkout") {
    } else if (newRoute == "/CashOnDelivery") {
    } else {}

    setState(() {
      route = newRoute;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _con_cart.listenForCarts();
    super.initState();
    Timer(Duration(seconds: 1), () {
      _con.toggleDelivery(selected: true);
      addressIsSet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList(context);
    list.paymentsList.removeWhere((element) {
      return element.id == "paypal";
    });
    list.paymentsList.removeWhere((element) {
      return element.id == "razorpay";
    });
    list.paymentsList.removeWhere((element) {
      return element.id == "visacard";
    });
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      bottomNavigationBar:
          CartBottomDetailsWidget(con: _con, paymentStep: "yes"),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).finalise,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Theme.of(context).hintColor,
        ),
        actions: [
          IconButton(
            onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
            color: Theme.of(context).hintColor,
            icon: Icon(Icons.person),
            iconSize: 35,
          )
        ],
        // actions: <Widget>[
        //   new ShoppingCartButtonWidget(
        //       iconColor: Theme.of(context).hintColor,
        //       labelColor: Theme.of(context).accentColor),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage("assets/img/map.jpg"),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Image.asset("assets/img/geo.jpg"),
                    )
                  ],
                )),
            Column(
              children: <Widget>[
                //  Padding(
                //     padding: const EdgeInsets.only(left: 20, right: 10),
                //     child: ListTile(
                //       contentPadding: EdgeInsets.symmetric(vertical: 0),
                //       leading: Icon(
                //         Icons.domain,
                //         color: Theme.of(context).hintColor,
                //       ),
                //       title: Text(
                //         S.of(context).pickup,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: Theme.of(context).textTheme.headline4,
                //       ),
                //       subtitle: Text(
                //         S.of(context).pickup_your_food_from_the_restaurant,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: Theme.of(context).textTheme.caption,
                //       ),
                //     ),
                //   ),
                // PickUpMethodItem(
                //     paymentMethod: _con.getPickUpMethod(),
                //     onPressed: (paymentMethod) {
                //       _con.togglePickUp();
                //     }),
                Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.map,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).delivery_address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: _con.carts.isNotEmpty &&
                                Helper.canDelivery(
                                    _con.carts[0].food.restaurant,
                                    carts: _con.carts)
                            ? Text(
                                S
                                    .of(context)
                                    .click_to_confirm_your_address_and_pay_or_long_press,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              )
                            : Text(""),
                      ),
                    ),

                    // _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].food.restaurant, carts: _con.carts)
                    //     ?
                    _con.deliveryAddress == null
                        ? CircularLoadingWidget(height: 250)
                        : DeliveryAddressesItemWidgetCheckout(
                            paymentMethod: _con.getDeliveryMethod(),
                            address: _con.deliveryAddress,
                            selected: false,
                            onPressed: (Address _address) {
                              //_con.addAddress(_con.deliveryAddress);
                              //addressIsSet = !addressIsSet;
                              // if (_con.deliveryAddress != null)
                              //   _con.toggleDelivery();
                            },
                            // onLongPress: (Address _address) {
                            //   if (_con.deliveryAddress.id != null){
                            //     DeliveryAddressDialog(
                            //       context: context,
                            //       address: _address,
                            //       onChanged: (Address _address) {
                            //         _con.updateAddress(_address);
                            //       },
                            //     );
                            //   }
                            // },
                          )
                    //: NotDeliverableAddressesItemWidget()
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _con.deliveryAddress = null;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DeliveryAddressesWidget())).then((value) {
                          addressIsSet = false;
                          _con.listenForDefaultAddress();
                          Timer(Duration(seconds: 2), () {
                            if (_con.deliveryAddress != null) {
                              if (mounted) {
                                _con.toggleDelivery(selected: true);
                                addressIsSet = true;
                              }
                            }
                          });
                        });
                      },
                      disabledColor:
                          Theme.of(context).focusColor.withOpacity(0.5),
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      child: Text('+ ' + S.of(context).add_delivery_address,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(
                                  color: Theme.of(context).primaryColor)))),
                ),
                SizedBox(height: 30),
                //Options de paiement
                list.paymentsList.length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.payment,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).payment_options,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                              S.of(context).select_your_preferred_payment_mode),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(height: 20),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: list.paymentsList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: PaymentMethodListItemWidget(
                          paymentMethod: list.paymentsList.elementAt(index),
                          changeRoute: changeRoute,
                          route: route),
                    );
                  },
                ),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: list.cashList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: PaymentMethodListItemWidget(
                          paymentMethod: list.cashList.elementAt(index),
                          changeRoute: changeRoute,
                          route: route),
                    );
                  },
                ),
                SizedBox(height: 10),
                Stack(
                  fit: StackFit.loose,
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: FlatButton(
                          onPressed: () async {
                            if (route == "/Checkout") {
                              await _con.addressAdded(_con.deliveryAddress);
                              Timer(Duration(seconds: 2), () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PayZonePaymentWidget()));
                              });
                              //vdialog.pop(context,"Le paiement par carte n'est pas disponible pour le moment !");
                            } else {
                              if (route != null && addressIsSet == true) {
                                await _con.addressAdded(_con.deliveryAddress);
                                resto_repo
                                    .getRestaurant(
                                        _con.carts[0].food.restaurant.id,
                                        address: _con.deliveryAddress)
                                    .then((restaurant) => restaurant.first
                                        .then((value) => Navigator.of(context)
                                            .pushReplacementNamed(route))
                                        .catchError((error) => vdialog.pop(
                                                context,
                                                "Ce restaurant ne couvre pas la zone de votre position actuelle !")
                                            //  _con.scaffoldKey?.currentState?.showSnackBar(
                                            //       SnackBar(
                                            //           content: Text(
                                            //               /*S.of(context).new_address_added_successfully*/

                                            //           ),
                                            //       )
                                            //  )
                                            ));
                              }
                            }
                            await FacebookEventsService.intsance.logEvent(
                              name:
                                  FacebookAppEvents.eventNameInitiatedCheckout,
                              parameters: {
                                FacebookAppEvents.paramNameContentType: 'Food',
                                FacebookAppEvents.paramNameContent:
                                    jsonEncode(_con.carts[0].food.toMap()),
                                FacebookAppEvents.paramNameContentId:
                                    _con.carts[0].food.id,
                                FacebookAppEvents.paramNamePaymentInfoAvailable:
                                    route.split('/').first,
                                'Adresse de livraison':
                                    json.encode(_con.deliveryAddress.toMap())
                              },
                            );
                            log('event loged with succes');
                          },
                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: route != null &&
                                  addressIsSet == true &&
                                  _con.deliveryAddress != null
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(S.of(context).checkout,
                              textAlign: TextAlign.start,
                              style: route != null &&
                                      addressIsSet == true &&
                                      _con.deliveryAddress != null
                                  ? Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))
                                  : Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(color: Theme.of(context).disabledColor)))),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Stack(
                  fit: StackFit.loose,
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Text("Revérifier votre panier",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)))),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
