import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key key,
      this.cart,
      this.heroTag,
      this.increment,
      this.decrement,
      this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Food',
              arguments: RouteArgument(
                  id: widget.cart.food.id, heroTag: widget.heroTag));
        },
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
              // color: Theme.of(context).primaryColor.withOpacity(0.9),
              // boxShadow: [
              //   BoxShadow(
              //       color: Theme.of(context).focusColor.withOpacity(0.1),
              //       blurRadius: 5,
              //       offset: Offset(0, 2)),
              // ],
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(5)),
              //   child: CachedNetworkImage(
              //     height: 90,
              //     width: 90,
              //     fit: BoxFit.cover,
              //     imageUrl: widget.cart.food.image.thumb,
              //     placeholder: (context, url) => Image.asset(
              //       'assets/img/loading.gif',
              //       fit: BoxFit.cover,
              //       height: 90,
              //       width: 90,
              //     ),
              //     errorWidget: (context, url, error) => Icon(Icons.error),
              //   ),
              // ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.cart.quantity.toInt().toString() +
                                      "x ",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.cart.food.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Wrap(
                            children: List.generate(widget.cart.extras.length,
                                (index) {
                              return Text(
                                  widget.cart.extras.elementAt(index).name +
                                      ', ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10));
                            }),
                          ),
                          // Wrap(
                          //   crossAxisAlignment: WrapCrossAlignment.center,
                          //   // spacing: 5,
                          //   children: <Widget>[
                          //     Helper.getPrice(widget.cart.food.price, context,
                          //         style: Theme.of(context).textTheme.headline4,
                          //         zeroPlaceholder: 'Free'),
                          //     widget.cart.food.discountPrice > 0
                          //         ? Helper.getPrice(
                          //             widget.cart.food.discountPrice, context,
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodyText1
                          //                 .merge(TextStyle(
                          //                     decoration:
                          //                         TextDecoration.lineThrough)))
                          //         : SizedBox(height: 0),
                          //     Text("x" + widget.cart.quantity.toString(),
                          //         style: Theme.of(context).textTheme.subtitle1),
                          //   ],
                          // ),

                          // context,
                          // style: Theme.of(context).textTheme.bodyText1.merge(
                          //   TextStyle(
                          //     decoration: TextDecoration.lineThrough
                          //   )
                          // )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 15,
                          // padding: EdgeInsets.symmetric(horizontal: 1),
                          icon: Icon(Icons.remove_circle),
                          color: Theme.of(context).accentColor,
                        ),

                        SizedBox(
                          width: 45,
                          child: widget.cart.food.discountPrice > 0
                              ? Helper.getPrice(widget.cart.food.price, context,
                                  style: Theme.of(context).textTheme.headline4,
                                  zeroPlaceholder: '0.00')
                              : Helper.getPrice(
                                  widget.cart.food.price * widget.cart.quantity,
                                  context,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                        ),
                        //Text(widget.cart.quantity.toString(), style: Theme.of(context).textTheme.subtitle1),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 15,
                          // padding: EdgeInsets.symmetric(horizontal: 1),
                          icon: Icon(Icons.add_circle),
                          color: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
