import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../store/refresh_model.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RefreshModel>(
        builder: (context, child, model) {
      return WillPopScope(
        onWillPop: Helper.of(context).onWillPop,
        child: Scaffold(
          key: UniqueKey(),
          bottomNavigationBar:
              CartBottomDetailsWidget(con: _con, paymentStep: null),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                if (widget.routeArgument != null) {
                  Navigator.of(context).pushReplacementNamed(
                      widget.routeArgument.param,
                      arguments: RouteArgument(id: widget.routeArgument.id));
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.arrow_back_ios_rounded),
              color: Theme.of(context).hintColor,
            ),
            // backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              S.of(context).cart,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _con.refreshCarts,
            child: _con.carts.isEmpty
                ? EmptyCartWidget()
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 120),
                            child: ListView(
                              primary: true,
                              children: <Widget>[
                                Text(
                                  "Ma Commande",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Divider(
                                  color: Color(0xFFECEFF1),
                                  height: 2,
                                  thickness: 2,
                                  // indent: 20,
                                  // endIndent: 20,
                                ),
                                ListView.separated(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
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
                                        // to remove refresh the card
                                        model.unRefresh();
                                      },
                                    );
                                  },
                                ),

                                //------------------------------------------------------------------
                                // Commentaires
                                //------------------------------------------------------------------

                                Text(
                                  "Commentaires",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Divider(
                                  color: Color(0xFFECEFF1),
                                  height: 2,
                                  thickness: 2,
                                  // indent: 20,
                                  // endIndent: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Card(
                                    color: Colors.grey.shade200,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade800),
                                        maxLines: 3,
                                        decoration: InputDecoration.collapsed(
                                            hintText:
                                                "Avez-vous des commentaires concernant votre commande?"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          padding: const EdgeInsets.all(18),
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, 2),
                                    blurRadius: 5.0)
                              ]),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            onSubmitted: (String value) {
                              _con.doApplyCoupon(value);
                            },
                            cursorColor: Theme.of(context).accentColor,
                            controller: TextEditingController()
                              ..text = coupon?.code ?? '',
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: Theme.of(context).textTheme.bodyText1,
                              suffixText: coupon?.valid == null
                                  ? ''
                                  : (coupon.valid
                                      ? S.of(context).validCouponCode
                                      : S.of(context).invalidCouponCode),
                              suffixStyle: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .merge(TextStyle(
                                      color: _con.getCouponIconColor())),
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(
                                  Icons.confirmation_number,
                                  color: _con.getCouponIconColor(),
                                  size: 28,
                                ),
                              ),
                              hintText: S.of(context).haveCouponCode,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
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
}
