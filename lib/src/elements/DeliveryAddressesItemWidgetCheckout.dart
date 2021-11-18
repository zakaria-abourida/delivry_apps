import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';

// ignore: must_be_immutable
class DeliveryAddressesItemWidgetCheckout extends StatelessWidget {
  final bool isCourier;
  String heroTag;
  model.Address address;
  PaymentMethod paymentMethod;
  bool selected;
  ValueChanged<model.Address> onPressed;
  ValueChanged<model.Address> onRightPress;
  ValueChanged<model.Address> onDismissed;

  DeliveryAddressesItemWidgetCheckout(
      {Key key,
      this.address,
      this.onPressed,
      this.onRightPress,
      this.onDismissed,
      this.paymentMethod,
      this.selected,
      this.isCourier = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onDismissed != null) {
      return Dismissible(
        key: Key(address.id),
        onDismissed: (direction) {
          this.onDismissed(address);
        },
        child: buildItem(context),
      );
    } else {
      return buildItem(context);
    }
  }

  InkWell buildItem(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      child: GestureDetector(
          onTap: () {
            this.onPressed(address);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 15, left: 5),
                              child: isCourier
                                  ? Container()
                                  : Image(
                                      height: 28,
                                      width: 16,
                                      image: AssetImage("assets/img/pin.png"),
                                      fit: BoxFit.fill),
                            ),
                          ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          address?.description != null
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 110,
                                  child: Text(
                                    address?.address ??
                                        S.of(context).add_delivery_address,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ))
                              : SizedBox(height: 0),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 110,
                              child: Text(
                                address.description ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                //style: address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1,
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          )),
    );
  }
}
