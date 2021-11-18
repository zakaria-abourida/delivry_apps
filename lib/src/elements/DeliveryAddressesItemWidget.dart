import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';

// ignore: must_be_immutable
class DeliveryAddressesItemWidget extends StatelessWidget {
  String heroTag;
  model.Address address;
  PaymentMethod paymentMethod;
  bool selected;
  ValueChanged<model.Address> onPressed;
  ValueChanged<model.Address> onRightPress;
  ValueChanged<model.Address> onDismissed;

  DeliveryAddressesItemWidget(
      {Key key,
      this.address,
      this.onPressed,
      this.onRightPress,
      this.onDismissed,
      this.paymentMethod,
      this.selected})
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
      onTap: () {
        log('selected address');
        this.onRightPress(address);
      },
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      child: Container(
        decoration: new BoxDecoration(
            color: address?.isDefault != null && address.isDefault
                ? Constants.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: new BorderRadius.circular(12.0)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).primaryColor.withOpacity(0.9),
        //   boxShadow: [
        //     BoxShadow(
        //         color: Theme.of(context).focusColor.withOpacity(0.1),
        //         blurRadius: 5,
        //         offset: Offset(0, 2)),
        //   ],
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Image(
                width: 20,
                image: AssetImage("assets/img/pin.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      address?.description != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width - 110,
                              child: Text(
                                address.address ?? address.description,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ))
                          : SizedBox(height: 0),
                      SizedBox(height: 4),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 110,
                          child: Row(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: Constants.primaryColor.withOpacity(0.9),
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                address?.description ??
                                    S.of(context).add_delivery_address,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                //style: address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1,
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11),
                              ),
                            ],
                          )),
                      address?.contact != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width - 110,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color:
                                        Constants.primaryColor.withOpacity(0.9),
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${address?.contact?.name}, ' ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11),
                                  ),
                                  Text(
                                    '${address?.contact?.phone}' ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11),
                                  ),
                                ],
                              ))
                          : Container()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
