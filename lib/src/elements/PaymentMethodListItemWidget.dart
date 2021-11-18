import 'package:flutter/material.dart';

import '../../constant.dart';
import '../helpers/custom_trace.dart';
import '../models/payment_method.dart';

// ignore: must_be_immutable
class PaymentMethodListItemWidget extends StatefulWidget {
  final bool isCourier;
  String heroTag;
  PaymentMethod paymentMethod;
  final changeRoute;
  String route;
  PaymentMethodListItemWidget(
      {Key key,
      this.paymentMethod,
      this.changeRoute,
      this.route,
      this.isCourier = false})
      : super(key: key);
  @override
  _PaymentMethodListItemWidgetState createState() =>
      _PaymentMethodListItemWidgetState();
}

class _PaymentMethodListItemWidgetState
    extends State<PaymentMethodListItemWidget> {
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        setState(() {
          checkedValue = !checkedValue;
        });
        if (checkedValue == true)
          widget.changeRoute(widget.paymentMethod.route);
        else
          widget.changeRoute(null);
        //Navigator.of(context).pushNamed(widget.paymentMethod.route);
        print(CustomTrace(StackTrace.current,
            message: widget.paymentMethod.name));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                  image: AssetImage(widget.paymentMethod.logo),
                  fit: BoxFit.fill),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   widget.paymentMethod.route == "/Checkout"
                      //       ? "Paiement par carte"
                      //       : widget.paymentMethod.name,
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 2,
                      //   style: TextStyle(
                      //       color: Colors.grey.shade700,
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 12),
                      // ),
                      Text(
                        widget.paymentMethod.route == "/Checkout"
                            ? "Paiement par Carte"
                            : widget.paymentMethod.description,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: widget.isCourier
                            ? Constants.courierTextStyle.copyWith(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'GothamBoldBook',
                                fontWeight: FontWeight.w600)
                            : TextStyle(
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                widget.route != null &&
                        widget.route == widget.paymentMethod.route
                    ? Checkbox(
                        value: true,
                        onChanged: (newValue) {
                          widget.changeRoute(null);
                        },
                      )
                    : Checkbox(
                        value: false,
                        onChanged: (newValue) {
                          widget.changeRoute(widget.paymentMethod.route);
                        },
                      ),
                // Icon(
                //   Icons.keyboard_arrow_right,
                //   color: Theme.of(context).focusColor,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
