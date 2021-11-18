import 'package:flutter/material.dart';

import '../../constant.dart';
import '../controllers/courier_order_controller.dart';
import '../helpers/helper.dart';
import '../helpers/vdialog.dart';
import '../models/address.dart';

class CourierBottomDetailsWidget extends StatefulWidget {
  final String paymentStep;
  final bool menupage;
  final CourierOrderController _con;
  final String route;
  final bool addressIsSet;
  final Address deliveryAddress;
  final VoidCallback beforeCheckout;

  CourierBottomDetailsWidget({
    Key key,
    this.menupage = false,
    this.paymentStep = null,
    this.beforeCheckout,
    this.addressIsSet = false,
    this.deliveryAddress = null,
    this.route = null,
    @required CourierOrderController con,
  })  : _con = con,
        super(key: key);

  // final GlobalKey<ScaffoldState> parentScaffoldKey;
  @override
  _CartBottomDetailsWidgetState createState() =>
      _CartBottomDetailsWidgetState();
}

class _CartBottomDetailsWidgetState extends State<CourierBottomDetailsWidget> {
  Vdialog vdialog = new Vdialog();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return widget.paymentStep != null
        ? SizedBox(height: 0)
        : Container(
            height: size.width * 0.36,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(children: [
                  widget._con.distanceMatrix != null
                      ? Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              "Livraison ${Helper.convertDistanceToKm(widget._con.distanceMatrix.distance.value)}",
                              style: TextStyle(
                                  fontFamily: "Gotham",
                                  color: Constants.primaryColor,
                                  fontSize: 22),
                            )),
                            Helper.getPrice(
                                Helper.calculateCourierFeesByDistance(
                                    widget._con.distanceMatrix.distance.value),
                                context,
                                style: TextStyle(
                                    fontFamily: "Gotham",
                                    color: Constants.primaryColor,
                                    fontSize: 22),
                                zeroPlaceholder: '0')
                          ],
                        )
                      : Container(),
                  SizedBox(height: 12),
                ]),
                widget._con.loading
                    ? SizedBox(
                        height: 37,
                        width: 37,
                        child: CircularProgressIndicator(
                            //valueColor: Constants.primaryColor,
                            ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                            onPressed: () {
                              widget._con.checkOrder();
                            },
                            disabledColor:
                                Theme.of(context).focusColor.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color:
                                /* widget.route != null &&
                              widget.addressIsSet == true &&
                              widget.deliveryAddress != null
                          ?  */
                                Theme.of(context).accentColor,
                            //: Theme.of(context).focusColor.withOpacity(0.5),
                            shape: StadiumBorder(),
                            child: Text(
                              "Confirmer la commande",
                              textAlign: TextAlign.start,
                              style:
                                  /* widget.route != null &&
                                  widget.addressIsSet == true &&
                                  widget.deliveryAddress != null
                              ?  */
                                  Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                              /* : Theme.of(context).textTheme.bodyText1.merge(
                                  TextStyle(
                                      color:
                                          Theme.of(context).disabledColor)) */
                            )),
                      ),
                SizedBox(height: 10),
              ],
            ),
          );
  }
}
