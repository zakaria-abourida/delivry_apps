import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/courier_order.dart';
import '../models/route_argument.dart';

class CourierOrderItemWidget extends StatefulWidget {
  final bool expanded;
  final CourierOrder order;
  final ValueChanged<void> onCanceled;

  CourierOrderItemWidget({Key key, this.expanded, this.order, this.onCanceled})
      : super(key: key);

  @override
  _CourierOrderItemWidgetState createState() => _CourierOrderItemWidgetState();
}

class _CourierOrderItemWidgetState extends State<CourierOrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    print(widget.order.toMap());
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.order.active ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      children: <Widget>[
                        Text('${S.of(context).order_id}: #${widget.order.id}'),
                        Text(
                          DateFormat('dd-MM-yyyy | HH:mm')
                              .format(widget.order.date),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Helper.getPrice(widget.order.amount, context,
                            style: Theme.of(context).textTheme.headline4),
                        Text(
                          '${widget.order.payment.method}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.comment,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(widget.order.amount, context,
                                    style:
                                        Theme.of(context).textTheme.headline4)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/CourierTrackingOrder',
                            arguments: RouteArgument(
                                id: widget.order.id.toString(),
                                param: widget.order));
                      },
                      textColor: Theme.of(context).accentColor,
                      child: Wrap(
                        children: <Widget>[
                          Text(S.of(context).tracking_order + " ")
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    // if (widget.order.canCancelOrder())
                    //   FlatButton(
                    //     onPressed: () {
                    //       showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           // return object of type Dialog
                    //           return AlertDialog(
                    //             title: Wrap(
                    //               spacing: 10,
                    //               children: <Widget>[
                    //                 Icon(Icons.report, color: Colors.orange),
                    //                 Text(
                    //                   S.of(context).confirmation,
                    //                   style: TextStyle(color: Colors.orange),
                    //                 ),
                    //               ],
                    //             ),
                    //             content: Text(S.of(context).areYouSureYouWantToCancelThisOrder),
                    //             contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                    //             actions: <Widget>[
                    //               FlatButton(
                    //                 child: new Text(
                    //                   S.of(context).yes,
                    //                   style: TextStyle(color: Theme.of(context).hintColor),
                    //                 ),
                    //                 onPressed: () {
                    //                   widget.onCanceled(widget.order);
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               ),
                    //               FlatButton(
                    //                 child: new Text(
                    //                   S.of(context).close,
                    //                   style: TextStyle(color: Colors.orange),
                    //                 ),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     },
                    //     textColor: Theme.of(context).hintColor,
                    //     child: Wrap(
                    //       children: <Widget>[Text(S.of(context).cancel + " ")],
                    //     ),
                    //     padding: EdgeInsets.symmetric(horizontal: 10),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width:  200 ,  
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: widget.order.active
                  ? Theme.of(context).accentColor
                  : Colors.redAccent),
          alignment: AlignmentDirectional.center,
          child: Text(
             widget.order.active
                ? statusTranslation(widget.order.orderStatusId.toString())
                : 
            S.of(context).canceled,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption.merge(
                TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }

  statusTranslation(status) {
    switch (status) {
      case "1":
        return 'En cours de v??rification';
        
        break;
      case "2":
        return 'Commande accept??e';
         
   
        break;

      case "3":
        return 'Commande accept??e';
          
      
        break;

      case "4":
      
        return  'Adresse de collecte';
         
        break;

      case "5":
        return 'En route';
         
        break;
      case "6":
        return 'Adressse de livraison';
        
        break;
      case "7":
        return 'Livr??e';
        
        break;
      case "8":
        return 'Annul??e';
        
        break;

      default:
        
          'Commande livr??e';
       break;
    }
    return status;
  }
}
