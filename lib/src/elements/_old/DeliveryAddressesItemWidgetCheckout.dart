import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../models/address.dart' as model;
import '../../models/payment_method.dart';

// ignore: must_be_immutable
class DeliveryAddressesItemWidgetCheckout extends StatelessWidget {
  String heroTag;
  model.Address address;
  PaymentMethod paymentMethod;  
  bool selected;
  ValueChanged<model.Address> onPressed;
  ValueChanged<model.Address> onRightPress;
  ValueChanged<model.Address> onDismissed;

  DeliveryAddressesItemWidgetCheckout({Key key, this.address, this.onPressed, this.onRightPress, this.onDismissed, this.paymentMethod, this.selected}) : super(key: key);

  
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
     
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    this.onPressed(address);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color:
                            (paymentMethod?.selected ?? false) || (selected == true ) ? Theme.of(context).accentColor : Theme.of(context).focusColor),
                    child: Icon(
                      (paymentMethod?.selected ?? false) || (selected == true ) ? Icons.check : Icons.place,
                      color: Theme.of(context).primaryColor,
                      size: 38,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                  onTap: () {
                    this.onRightPress(address);
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        address?.description != null
                            ? SizedBox(width: MediaQuery.of(context).size.width - 130, 
                                child:Text(
                                  address.description,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              )
                            : SizedBox(height: 0),
                            SizedBox(width: MediaQuery.of(context).size.width - 130, 
                                child:Text(
                                  address?.address ?? S.of(context).add_delivery_address,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  //style: address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1,
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ),
                            SizedBox(width: MediaQuery.of(context).size.width - 130, 
                                    child:Text(
                                      address?.longitude != null ? address?.longitude.toString() +", "+address?.latitude.toString()  :  "",                           
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      //style: address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1,
                                      style: Theme.of(context).textTheme.caption,
                                    )
                            ),
                      ],
                    
                    ),                   
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
