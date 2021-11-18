import 'dart:developer';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';

class CartBottomDetailsWidget extends StatefulWidget {
  //Bg Color = "primary " or "white" or "grey"
  // final GlobalKey<ScaffoldState> parentScaffoldKey;
  // final String bgColor;

  // CartBottomDetailsWidget({Key key, this.parentScaffoldKey, this.bgColor = "primary"})
  //     : preferredSize = Size.fromHeight(kToolbarHeight),
  //       super(key: key);

  // @override
  // final Size preferredSize; // default is 56.0

  // @override
  // _CartBottomDetailsWidgetState createState() => _CartBottomDetailsWidgetState();

  final String paymentStep;
  final bool menupage;
  final CartController _con;
  final String route;
  final bool addressIsSet;
  final Address deliveryAddress;
  final VoidCallback beforeCheckout;

  CartBottomDetailsWidget({
    Key key,
    this.menupage = false,
    this.paymentStep = null,
    this.beforeCheckout,
    this.addressIsSet = false,
    this.deliveryAddress = null,
    this.route = null,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  // final GlobalKey<ScaffoldState> parentScaffoldKey;
  @override
  _CartBottomDetailsWidgetState createState() =>
      _CartBottomDetailsWidgetState();
}

class _CartBottomDetailsWidgetState extends State<CartBottomDetailsWidget> {
  Vdialog vdialog = new Vdialog();

  @override
  Widget build(BuildContext context) {
    log('MENU PAGE VALUE ' + widget.menupage.toString());

    return widget._con.carts.isEmpty || widget.paymentStep != null
        ? SizedBox(height: 0)
        : Container(
            height: widget.menupage
                ? (widget._con.coupon1?.valid == true &&
                        widget._con.coupon1.discount > 0
                    ? 125
                    : 105)
                : 200,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  !widget.menupage
                      ? Column(children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Sous-total",
                                ),
                              ),
                              widget._con.iscop
                                  ? Helper.getPrice(
                                      widget._con.oldTotal, context,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      zeroPlaceholder: '0')
                                  : Helper.getPrice(
                                      widget._con.subTotal, context,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      zeroPlaceholder: '0'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                ),
                              ),
                              //Condition
                              Helper.getPrice(
                                  widget._con.carts[0].food.restaurant
                                      .deliveryFee,
                                  context,
                                  style: Theme.of(context).textTheme.caption,
                                  zeroPlaceholder: '00')
                            ],
                          ),
                          widget._con.coupon1.valid != null &&
                                  (widget._con.coupon1.discount > 0 &&
                                      widget._con.oldTotal > 60)
                              ? (Row(
                                  children: [
                                    Expanded(child: Text("Code promo")),
                                    Text("-"),
                                    Helper.getPrice(
                                        widget._con.coupon1.discount, context,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        zeroPlaceholder: '00'),
                                  ],
                                ))
                              : SizedBox(height: 0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).subtotal,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              Helper.getPrice(
                                  widget._con.subTotal +
                                      (widget._con.carts[0].food.restaurant
                                              .deliveryFee ??
                                          0),
                                  context,
                                  style: Theme.of(context).textTheme.headline6,
                                  zeroPlaceholder: '0')
                            ],
                          ),
                          SizedBox(height: 20),
                        ])
                      : SizedBox(height: 5),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: widget.menupage
                            ? Column(
                                children: [
                                  widget._con.coupon1.valid != null &&
                                          (widget._con.coupon1.discount > 0 &&
                                              widget._con.oldTotal > 60)
                                      ? (Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, bottom: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text("Code promo")),
                                              Text("-"),
                                              Helper.getPrice(
                                                  widget._con.coupon1.discount,
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                  zeroPlaceholder: '00'),
                                            ],
                                          )))
                                      : SizedBox(height: 0),
                                  FlatButton(
                                      onPressed: () {
                                        double price = 0;
                                        if (widget._con.coupon1?.valid ==
                                            true) {
                                          price = widget._con.coupon1.discount;
                                        }
                                        if (widget._con.total.value + price >=
                                            30) {
                                          // widget.pushToCart();
                                          widget._con.goCheckout(context);
                                        } else {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Votre commande doit dépasser 30 MAD"),
                                          ));
                                        }
                                      },
                                      disabledColor: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      color: !widget._con.carts[0].food
                                              .restaurant.closed
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.5),
                                      shape: StadiumBorder(),
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    220,
                                                child: Row(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'assets/img/panier.png'),
                                                      width: 32,
                                                      height: 28,
                                                    ),
                                                    Text(
                                                      "  Mon panier :",
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: ValueListenableBuilder(
                                                    valueListenable:
                                                        widget._con.total,
                                                    builder: (context, value,
                                                        child) {
                                                      return Helper.getPrice(
                                                          value +
                                                              widget
                                                                  ._con
                                                                  .carts[0]
                                                                  .food
                                                                  .restaurant
                                                                  .deliveryFee,
                                                          context,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline4
                                                              .merge(TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor)),
                                                          zeroPlaceholder:
                                                              '00');
                                                    }),
                                              )
                                            ],
                                          ))),
                                ],
                              )
                            : FlatButton(
                                onPressed: () async {
                                  if (widget.menupage == false) {
                                    if (widget._con.coupon1.valid != null) {
                                      if (widget._con.coupon1.valid &&
                                          widget._con.oldTotal >= 60) {
                                        widget.beforeCheckout();
                                      } else if (widget._con.coupon1.valid &&
                                          widget._con.oldTotal < 60) {
                                        vdialog.pop(context,
                                            "Pour qu'un coupon soit appliqué la commande doit dépasser 60 MAD");
                                      }
                                    } else {
                                      widget.beforeCheckout();
                                    }
                                  }
                                },
                                disabledColor: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color: widget.route != null &&
                                        widget.addressIsSet == true &&
                                        widget.deliveryAddress != null
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5),
                                shape: StadiumBorder(),
                                child: Text("Confirmer la commande",
                                    textAlign: TextAlign.start,
                                    style: widget.route != null &&
                                            widget.addressIsSet == true &&
                                            widget.deliveryAddress != null
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(color: Theme.of(context).disabledColor)))),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
}

// ValueListenableBuilder(
//                                   valueListenable: widget._con.total,
//                                   builder: (context, value, child) {
//                                     return Helper.getPrice(value, context,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headline4
//                                             .merge(TextStyle(
//                                                 color: Theme.of(context)
//                                                     .primaryColor)),
//                                         zeroPlaceholder: 'Free');
//                                   })

// SizedBox(
//                     width: MediaQuery.of(context).size.width - 40,
//                     child:

// FlatButton(
//                       onPressed: () {
//                         if (widget.menupage) {
//                           // widget.pushToCart();
//                           widget._con.goCheckout(context);
//                         } else if (widget.paymentStep == null) {
//                           if (widget._con.coupon1.valid != null) {
//                             if (widget._con.coupon1.valid &&
//                                 widget._con.oldTotal >= 80) {
//                               widget._con.goCheckout(context);
//                             } else if (widget._con.coupon1.valid &&
//                                 widget._con.oldTotal < 80) {
//                               vdialog.pop(context,
//                                   "Pour qu'un coupon soit appliqué la commande doit dépasser 80 MAD");
//                             }
//                             // Scaffold.of(context).showSnackBar(SnackBar(
//                             //   content: Text("Pour qu'un coupon soit appliqué la commande doit dépasser 80 MAD"),
//                             // ));
//                           } else if (widget._con.total.value >= 30) {
//                             widget._con.goCheckout(context);
//                           } else {
//                             Scaffold.of(context).showSnackBar(SnackBar(
//                               content: Text(
//                                   "Votre commande doit dépasser 30 MAD"),
//                             ));
//                           }
//                         }
//                       },
//                       disabledColor:
//                           Theme.of(context).focusColor.withOpacity(0.5),
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                       color: !widget._con.carts[0].food.restaurant.closed
//                           ? Theme.of(context).accentColor
//                           : Theme.of(context).focusColor.withOpacity(0.5),
//                       shape: StadiumBorder(),
//                       child: Padding(
//         padding: const EdgeInsets.only(left: 20),
//         child: Row(
//           children: [
//             Image(
//               image: AssetImage(
//                   'assets/img/panier.png'),
//               width: 32,
//               height: 28,
//             ),
//             Text(
//               "  Mon panier :",
//               style: TextStyle(
//                   color: Theme.of(context)
//                       .primaryColor),
//             )
//           ],
//         ))
// ),

//                           : Text(
//                               "Revérifier votre panier",
//                               textAlign: TextAlign.start,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyText1
//                                   .merge(TextStyle(
//                                       color:
//                                           Theme.of(context).primaryColor)),
//                             ),
//                     ),
//                   ),
// widget.paymentStep == null
//     ? Padding(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 20),
//         child: ValueListenableBuilder(
//             valueListenable: widget._con.total,
//             builder: (context, value, child) {
//               return Helper.getPrice(value, context,
//                   style: Theme.of(context)
//                       .textTheme
//                       .headline4
//                       .merge(TextStyle(
//                           color: Theme.of(context)
//                               .primaryColor)),
//                   zeroPlaceholder: 'Free');
//             }))
//     : Text("")
