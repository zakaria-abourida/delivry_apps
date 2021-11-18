import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scoped_model/scoped_model.dart';

import '../controllers/cart_controller.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/DeliveryAddressesItemWidgetCheckout.dart';
import '../elements/EmptyCartWidget.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../helpers/helper.dart';
import '../helpers/maps_util.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';
import '../models/distance_matrix.dart';
import '../models/payment_method.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../models/zoning_fields.dart';
import '../pages/delivery_addresses.dart';
import '../pages/payzone_payment.dart';
import '../repository/restaurant_repository.dart' as resto_repo;
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../services/facebook_services.dart';
import '../store/refresh_model.dart';
import '../widget/AppBarWebili.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  TextEditingController couponInputController = new TextEditingController();
  TextEditingController commentInputController = new TextEditingController();
  DeliveryPickupController _con;
  CartController _con_cart = new CartController();
  bool addressIsSet = false;
  PaymentMethodList list;
  bool showCouponMessage = false;
  String comment;
  Vdialog vdialog = new Vdialog();
  ZoningFields zoningFields;
  String restaurantId;
  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  // route != null &&
  // addressIsSet == true &&
  // settingRepo.deliveryAddress.value != null

  // ValueNotifier<bool> addressIsSet = ValueNotifier<bool>(false);
  // ValueNotifier<String> route = ValueNotifier<String>(null);

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
    couponInputController.text = coupon?.code;
    _con_cart.listenForCarts();
    super.initState();
    Timer(Duration(seconds: 1), () {
      _con.toggleDelivery(selected: true);
      addressIsSet = true;
    });

    final restaurant = widget.routeArgument.param as Restaurant;
    restaurantId = restaurant.id;
    if (restaurant.addresses.length > 0) {
      log("RESTAURANT ADDRESSES ===> " +
          restaurant.addresses.map((e) => e.toJson()).toString());
      final origin = new LatLng(settingRepo.deliveryAddress.value.latitude,
          settingRepo.deliveryAddress.value.longitude);
      List<LatLng> destinations = [];
      restaurant.addresses.forEach((element) {
        destinations.add(new LatLng(
            double.parse(element.latitude), double.parse(element.longitude)));
      });
      MapsUtil()
          .getMultiDestinationsDistanceMatrix(origin, destinations)
          .then((value) {
        log(value.map((e) => e.toJson()).toString());
        DistanceMatrix lessesDistance = value.first;
        value.forEach((element) {
          if (element.distance.value < lessesDistance.distance.value) {
            lessesDistance = element;
          }
        });
        final indexOfLessesDistance = value.indexOf(lessesDistance);
        zoningFields = new ZoningFields(
            restaurantAddressId: restaurant.addresses[indexOfLessesDistance].id,
            deliveryAmount: Helper.calculateCourierFeesByDistance(
                lessesDistance.distance.value),
            distance:
                Helper.simpleConvertDistanceToKm(lessesDistance.distance.value),
            time:
                (lessesDistance.duration.value / 60).ceilToDouble().toString());
        log("zoningFields ==>" + zoningFields.toMap().toString());
      });
    } else {
      log("RESTAURANT DEFAULT ADDRESS ===> " +
          restaurant.latitude +
          "/" +
          restaurant.longitude);
      final origin = new LatLng(settingRepo.deliveryAddress.value.latitude,
          settingRepo.deliveryAddress.value.longitude);
      final destination = new LatLng(double.parse(restaurant.latitude),
          double.parse(restaurant.longitude));
      MapsUtil().getDistanceMatrix(origin, destination).then((value) {
        log(value.toJson().toString());
        if (value != null) {
          zoningFields = new ZoningFields(
              restaurantAddressId: null,
              deliveryAmount:
                  Helper.calculateCourierFeesByDistance(value.distance.value),
              distance: Helper.simpleConvertDistanceToKm(value.distance.value),
              time: (value.duration.value / 60).ceilToDouble().toString());
          log("zoningFields ==>" + zoningFields.toMap().toString());
        }
      });
    }
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
    return ScopedModelDescendant<RefreshModel>(
        builder: (context, child, model) {
      return WillPopScope(
        onWillPop: Helper.of(context).onWillPop,
        child: Scaffold(
          key: UniqueKey(),
          bottomNavigationBar: CartBottomDetailsWidget(
              con: _con,
              paymentStep: null,
              beforeCheckout: beforeCheckout,
              route: route,
              addressIsSet: addressIsSet,
              deliveryAddress: settingRepo.deliveryAddress.value),
          appBar: AppBarWebili(
            bgColor: "grey",
          ),
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: _con.refreshCarts,
            child: _con.carts.isEmpty
                ? EmptyCartWidget()
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: ListView(
                            primary: true,
                            children: <Widget>[
                              Text("Ma Commande",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w600)),
                              Divider(
                                color: Color(0xFFECEFF1),
                                height: 2,
                                thickness: 2,
                                // indent: 20,
                                // endIndent: 20,
                              ),
                              Text(
                                "Glisser à gauche pour supprimer",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 8),
                              ),

                              ListView.separated(
                                padding: EdgeInsets.only(top: 5, bottom: 15),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: _con.carts.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 5);
                                },
                                itemBuilder: (context, index) {
                                  return CartItemWidget(
                                    cart: _con.carts.elementAt(index),
                                    heroTag: 'cart' + index.toString(),
                                    increment: () {
                                      _con.incrementQuantity(
                                          _con.carts.elementAt(index));
                                    },
                                    decrement: () {
                                      _con.decrementQuantity(
                                          _con.carts.elementAt(index));
                                    },
                                    onDismissed: () {
                                      _con.onRemove();
                                      // to refresh the card
                                      model.refresh();

                                      _con.removeFromCart(
                                          _con.carts.elementAt(index));

                                      _con.listenForCarts();
                                      // to remove refresh the card
                                      model.unRefresh();
                                    },
                                  );
                                },
                              ),

                              //------------------------------------------------------------------
                              // Adresse de livraison
                              //------------------------------------------------------------------

                              Text(
                                "Adresse de livraison",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                color: Color(0xFFECEFF1),
                                height: 2,
                                thickness: 2,
                                // indent: 20,
                                // endIndent: 20,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: settingRepo.deliveryAddress.value ==
                                          null
                                      ? SizedBox(
                                          child: FlatButton(
                                              onPressed: () {
                                                setAddress();
                                              },
                                              disabledColor: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3, horizontal: 10),
                                              color: Colors.transparent,
                                              shape: StadiumBorder(),
                                              child: Text(
                                                  '+ Ajouter une adresse',
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .merge(TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor)))),
                                        )
                                      : DeliveryAddressesItemWidgetCheckout(
                                          paymentMethod:
                                              _con.getDeliveryMethod(),
                                          address:
                                              settingRepo.deliveryAddress.value,
                                          selected: false,
                                          onPressed: (Address _address) {
                                            setAddress();
                                            //_con.addAddress(settingRepo.deliveryAddress.value);
                                            //addressIsSet = !addressIsSet;
                                            // if (settingRepo.deliveryAddress.value != null)
                                            //   _con.toggleDelivery();
                                          },
                                          // onLongPress: (Address _address) {
                                          //   if (settingRepo.deliveryAddress.value.id != null){
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
                                  ),

                              SizedBox(height: 15),
                              //Options de paiement
                              Text(
                                "Mode de paiement",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                color: Color(0xFFECEFF1),
                                height: 2,
                                thickness: 2,
                                // indent: 20,
                                // endIndent: 20,
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
                                        paymentMethod:
                                            list.cashList.elementAt(index),
                                        changeRoute: changeRoute,
                                        route: route),
                                  );
                                },
                              ),
                              ListView.separated(
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: list.paymentsList.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 0);
                                },
                                itemBuilder: (context, index) {
                                  return PaymentMethodListItemWidget(
                                      paymentMethod:
                                          list.paymentsList.elementAt(index),
                                      changeRoute: changeRoute,
                                      route: route);
                                },
                              ),

                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Code Promo",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0, left: 0),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
                                      height: 25,
                                      width: 135,
                                      // color: Colors.grey[100],

                                      child: TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: couponInputController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(top: 5),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .caption,
                                            suffixStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: _con
                                                        .getCouponIconColor())),
                                            hintText: "______",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.2))),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.5))),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.2))),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: FlatButton(
                                        onPressed: () {
                                          _con.doApplyCoupon(
                                              couponInputController.text);
                                        },
                                        height: 25,
                                        disabledColor: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 1),
                                        color: Theme.of(context).accentColor,
                                        shape: StadiumBorder(),
                                        child: Text('Appliquer',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white))),
                                  )
                                ],
                              ),
                              coupon?.valid == null
                                  ? SizedBox()
                                  : (coupon.valid
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Code promo valide pour les commandes supérieures à 60 Dhs",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10,
                                                ))
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Ce code promo n'est pas valide",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 10,
                                                ))
                                          ],
                                        )),
                              SizedBox(height: 15),

                              //------------------------------------------------------------------
                              // Commentaires
                              //------------------------------------------------------------------

                              Text(
                                "Commentaires",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Divider(
                                color: Color(0xFFECEFF1),
                                height: 2,
                                thickness: 2,
                                // indent: 20,
                                // endIndent: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Card(
                                  color: Colors.grey.shade200,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onChanged: (value) =>
                                          _con.setComment(value),
                                      controller: commentInputController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800),
                                      maxLines: 3,
                                      decoration: InputDecoration.collapsed(
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade400),
                                          hintText:
                                              "Avez-vous des commentaires concernant votre commande?"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      );
    });
  }

  onValueChange(value) {
    comment = value;
  }

  setAddress() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => DeliveryAddressesWidget()))
        .then((value) {
      addressIsSet = false;
      // _con.listenForDefaultAddress();
      Timer(Duration(seconds: 2), () {
        if (settingRepo.deliveryAddress.value != null) {
          if (mounted) {
            _con.toggleDelivery(selected: true);
            addressIsSet = true;
          }
        }
      });
    });
  }

  beforeCheckout() async {
    log('beforeCheckout route param ==> $route');
    if (route == "/Checkout") {
      await _con.addressAdded(settingRepo.deliveryAddress.value);
      Timer(Duration(seconds: 2), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PayZonePaymentWidget(
                      zoningFields: zoningFields,
                      restaurantId: restaurantId,
                    )));
      });
      //vdialog.pop(context,"Le paiement par carte n'est pas disponible pour le moment !");
    } else {
      log('address  ==> ${settingRepo.deliveryAddress.value.toMap()}');
      if (settingRepo.deliveryAddress.value.id == null ||
          settingRepo.deliveryAddress.value.id == "null") {
        _con
            .addressAdded(settingRepo.deliveryAddress.value)
            .then((value) async {
          if (value != null) {
            await resto_repo
                .getRestaurant(_con.carts[0].food.restaurant.id,address: value)
                .then((restaurant) => restaurant.first
                    .then((value) => Navigator.of(context).pushReplacementNamed(
                        route,
                        arguments: RouteArgument(
                            id: 'Cash on Delivery', param: zoningFields)))
                    .catchError((error) => vdialog.pop(context,
                        "Ce restaurant ne couvre pas la zone de votre position actuelle !")));
          }
        });
      } else {
        await resto_repo
            .getRestaurant(_con.carts[0].food.restaurant.id,address:
                settingRepo.deliveryAddress.value)
            .then((restaurant) => restaurant.first
                .then((value) => Navigator.of(context).pushReplacementNamed(
                    route,
                    arguments: RouteArgument(
                        id: 'Cash on Delivery', param: zoningFields)))
                .catchError((error) => vdialog.pop(context,
                    "Ce restaurant ne couvre pas la zone de votre position actuelle !")));
      }
    }
    await FacebookEventsService.intsance.logEvent(
      name: FacebookAppEvents.eventNameInitiatedCheckout,
      parameters: {
        FacebookAppEvents.paramNameContentType: 'Food',
        FacebookAppEvents.paramNameContent:
            jsonEncode(_con.carts[0].food.toMap()),
        FacebookAppEvents.paramNameContentId: _con.carts[0].food.id,
        FacebookAppEvents.paramNamePaymentInfoAvailable: route.split('/').first,
        'Adresse de livraison':
            json.encode(settingRepo.deliveryAddress.value.toMap())
      },
    );
    log('event loged with succes');
  }
}

//  TextField(
//                                 keyboardType: TextInputType.text,
//                                 onSubmitted: (String value) {
//                                   _con.doApplyCoupon(value);
//                                 },
//                                 cursorColor: Theme.of(context).accentColor,
//                                 controller: TextEditingController()
//                                   ..text = coupon?.code ?? '',
//                                 decoration: InputDecoration(
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 15),
//                                   floatingLabelBehavior:
//                                       FloatingLabelBehavior.always,
//                                   hintStyle:
//                                       Theme.of(context).textTheme.bodyText1,
//                                   suffixText: coupon?.valid == null
//                                       ? ''
//                                       : (coupon.valid
//                                           ? S.of(context).validCouponCode
//                                           : S.of(context).invalidCouponCode),
//                                   suffixStyle: Theme.of(context)
//                                       .textTheme
//                                       .caption
//                                       .merge(TextStyle(
//                                           color: _con.getCouponIconColor())),
//                                   // suffixIcon: Padding(
//                                   //   padding: const EdgeInsets.symmetric(
//                                   //       horizontal: 15),
//                                   //   child: Icon(
//                                   //     Icons.confirmation_number,
//                                   //     color: _con.getCouponIconColor(),
//                                   //     size: 28,
//                                   //   ),
//                                   // ),
//                                   hintText: S.of(context).haveCouponCode,
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                       borderSide: BorderSide(
//                                           color: Theme.of(context)
//                                               .focusColor
//                                               .withOpacity(0.2))),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                       borderSide: BorderSide(
//                                           color: Theme.of(context)
//                                               .focusColor
//                                               .withOpacity(0.5))),
//                                   enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                       borderSide: BorderSide(
//                                           color: Theme.of(context)
//                                               .focusColor
//                                               .withOpacity(0.2))),
//                                 ),
//                               ),
