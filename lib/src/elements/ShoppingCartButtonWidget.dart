import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../pages/cart.dart';


class ShoppingCartButtonWidget extends StatefulWidget {
  const ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartButtonWidgetState createState() => _ShoppingCartButtonWidgetState();
}

class _ShoppingCartButtonWidgetState extends StateMVC<ShoppingCartButtonWidget> {
  CartController _con;
  //  Timer timer;

  _ShoppingCartButtonWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCartsCount();
    super.initState();
    //timer = Timer.periodic(Duration(seconds: 2), (Timer t) => _con.listenForBottomCartsCount());
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        //_con2.refreshRestaurantList();
        Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartWidget()
              )
            );
          //Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: '/Pages', id: '2'));
        
        // } else {
        //   Navigator.of(context).pushNamed('/Login');
        // }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.shopping_cart,
            color: this.widget.iconColor,
            size: 28,
          ),
          Container(
            child:             
              // new FutureBuilder(
              //     future: SharedPreferences.getInstance(),
              //     builder: (BuildContext context,
              //     AsyncSnapshot<SharedPreferences> snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting)
              //     return new Text("");

              //     else if (snapshot.requireData.getString('cartCount') != null)
              //     return new Text(
              //             snapshot.requireData.getString('cartCount'),
              //             textAlign: TextAlign.center,
              //             style: Theme.of(context).textTheme.caption.merge(
              //                   TextStyle(color: Theme.of(context).primaryColor, fontSize: 9),
              //                 ),
              //           );
                  
              //     else
              //     return new Text(
              //             "0",
              //             textAlign: TextAlign.center,
              //             style: Theme.of(context).textTheme.caption.merge(
              //                   TextStyle(color: Theme.of(context).primaryColor, fontSize: 9),
              //                 ),
              //           );
              //     }),
            
            Text(
              _con.cartCount.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.merge(
                    TextStyle(color: Theme.of(context).primaryColor, fontSize: 9),
                  ),
            ),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: this.widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
