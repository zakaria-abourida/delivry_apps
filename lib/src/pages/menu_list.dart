import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../controllers/food_controller.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/vdialog.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../pages/cart.dart';
import '../repository/user_repository.dart';
import '../widget/AppBarWebili.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;
  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  RestaurantController _con;
  CartController _conCart;
  FoodController _conFood;
  String restaurant_name = null;
  Vdialog vdialog = new Vdialog();
  bool closed = false;
  List<String> selectedCategories;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var category;
  final String time = "20-30 min";
  bool allowGoBack = false;

  _MenuWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void dispose() {
    // close the webview here
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _conCart = new CartController();
    _conCart.listenForCarts();
    _conFood = new FoodController();
    _conFood.listenForCart();
    _con.restaurant = widget.routeArgument.param as Restaurant;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_con.restaurant == null) {
        /*  Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Material(color: Colors.white, child: EmptyOrdersWidget()))); */
        /*  vdialog
            .pop(context,
                "Ce restaurant ne couvre pas la position que vous avez sélectionné")
            .whenComplete(() => Navigator.of(_con.scaffoldKey.currentContext)
                .pushReplacementNamed('/Home')); */
      } else {
        _con.listenForCategories(_con.restaurant?.id);
        _con.listenForFoods(_con.restaurant?.id);

        this.restaurant_name = _con.restaurant.name;

        Timer(Duration(seconds: 3), () {
          setState(() {
            if (currentUser.value.id == "150") {
              this.closed = false;
            } else {
              this.closed = _isClosed();
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_con.restaurant == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWebili(
            parentScaffoldKey: _scaffoldKey,
            showActionIcon: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: config.App(context).appHeight(70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7),
                                    Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.05),
                                  ])),
                          child: Icon(
                            Icons.wrong_location,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 70,
                          ),
                        ),
                        Positioned(
                          right: -30,
                          bottom: -50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20,
                          top: -50,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        "Ce restaurant ne couvre pas la position que vous avez sélectionné",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .merge(TextStyle(fontWeight: FontWeight.w300)),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ));
    }
    rating() {
      List<Widget> listWidget = new List<Widget>();

      for (int i = 0; i < double.parse(_con.restaurant.rate).toInt(); i++) {
        listWidget.add(new Icon(
          Icons.star,
          color: Constants.primaryColor,
          size: 14,
        ));
      }
      for (int i = 0; i < 5 - double.parse(_con.restaurant.rate).toInt(); i++) {
        listWidget.add(new Icon(
          Icons.star,
          color: Colors.grey.shade700,
          size: 14,
        ));
      }

      return Row(children: listWidget);
    }

    print(_conCart.total.value.toString());
    return WillPopScope(
        onWillPop: () => beforeGoBack(),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DrawerWidget(),
          backgroundColor: Colors.white,
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _conCart.total,
              builder: (context, value, child) {
                print("listened builder:" + value.toString());
                return value > 0
                    ? CartBottomDetailsWidget(    
                        con: _conCart,
                        paymentStep: null,
                        menupage: true,
                        beforeCheckout: null)
                    : SizedBox(height: 0);
              }),
          appBar: AppBarWebili(
              parentScaffoldKey: _scaffoldKey,
              beforeGoBack: () => this.beforeGoBack()),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  leading: Hero(
                    tag: "resto" + _con.restaurant.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        imageUrl: _con.restaurant.image.thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 190,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _con.restaurant?.name ?? '',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              _con.restaurant.description != null
                                  ? Text(
                                      parse(_con.restaurant.description)
                                          .documentElement
                                          .text,
                                      style:
                                          Theme.of(context).textTheme.caption)
                                  : Text('')
                            ]),
                      ),
                      Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Row(children: [
                              Icon(
                                Icons.alarm_outlined,
                                size: 10,
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 12),
                              ),
                            ])),
                        rating(),
                      ]),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Hero(
                              tag: "restox" + _con.restaurant.id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: _con.restaurant.image.url,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            _isClosed()
                                ? Positioned(
                                    child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Image.asset("assets/img/ferme.png",
                                        fit: BoxFit.fill),
                                  ))
                                : Text(''),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(children: [
                              Row(children: [
                                Image(
                                  image: AssetImage('assets/img/moto.png'),
                                  width: 14,
                                  height: 14,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2, top: 3),
                                  child: Text(
                                    _con.restaurant.deliveryFee.toString() +
                                        '0 MAD',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  ),
                                )
                              ])
                            ]),
                          ],
                        ),
                      ],
                    )),
                _con.foods.isEmpty || _con.categories.isEmpty
                    ? CircularLoadingWidget(height: 250)
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.categories.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 0);
                        },
                        itemBuilder: (context, index) {
                          this.category = _con.categories.elementAt(index);
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                child: Text(
                                  _con.categories.elementAt(index).name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: _con.foods.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 0);
                                },
                                itemBuilder: (context, index) {
                                  return this._listOfFood(context, index);
                                },
                              )
                            ],
                          );
                        })
              ],
            ),
          ),
        ));
  }

  beforeGoBack() async {
    if (_conCart.carts.length > 0) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(S.of(context).reset_cart),
            contentPadding: EdgeInsets.symmetric(vertical: 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  child: Text(
                    "Si vous quitter le restaurant, votre panier sera vider !",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: new Text(S.of(context).reset),
                onPressed: () {
                  allowGoBack = true;
                  _conCart
                      .emptyCart()
                      .then((value) => Navigator.of(context).pop());
                },
              ),
              FlatButton(
                child: new Text(S.of(context).close),
                onPressed: () {
                  allowGoBack = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).whenComplete(
          () => allowGoBack == true ? Navigator.of(context).pop() : false);
    } else
      Navigator.of(context).pop();
  }

  _listOfFood(context, index) {
    final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
    var _food = _con.foods.elementAt(index);
    if (this.category.id == _food.category.id) {
      //food composé
      if (_food.is_parent != null && _food.is_parent) {
        List<Food> food_childs = _food.foods;
        return ExpansionTileCard(
          key: cardA,
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: CachedNetworkImage(
              height: 60,
              width: 60,
              fit: BoxFit.cover,
              imageUrl: _food.image.thumb,
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          title: Text(_food.name),
          // subtitle: Text('I expand!'),
          children: <Widget>[
            ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: food_childs.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 0);
                },
                itemBuilder: (context, index) {
                  if (food_childs.elementAt(index).deliverable) {
                    return FoodItemWidget(
                        heroTag: 'children_menu_list',
                        food: food_childs.elementAt(index),
                        closed: this.closed,
                        pushToExtras: () => this.pushToExtras(
                            food_childs.elementAt(index),
                            'children_menu_list'));
                  }
                })
          ],
        );
      }

      //food normal
      if (_food.toMap()["parent_id"] == "null" && _food.deliverable) {
        return FoodItemWidget(
            heroTag: 'menu_list',
            food: _food,
            closed: this.closed,
            pushToExtras: () => this.pushToExtras(_food, 'menu_list'));
      }

      return SizedBox(height: 0);
    } else {
      return SizedBox(height: 0);
    }
  }

  _isClosed() {
    if (_con.restaurant.start_time == null || _con.restaurant.end_time == null)
      return true;

    DateFormat dateFormat = new DateFormat.Hm();
    DateTime now = DateTime.now();

    DateTime open = dateFormat.parse(_con.restaurant.start_time);
    open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);

    DateTime close = dateFormat.parse(_con.restaurant.end_time);
    close =
        new DateTime(now.year, now.month, now.day, close.hour, close.minute);

    bool closed = (now.isBefore(open) || now.isAfter(close));
    return closed;
  }

  pushToCart() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartWidget()))
        .then((val) {
          
      print('coming back to menu list');
      _conCart.listenForCarts();
      setState(() {});
    });
  }

  pushToExtras(food, heroTag) {
    if (food.extras.length > 0) {
      Navigator.of(context)
          .pushNamed('/Food',
              arguments: RouteArgument(id: food.id, heroTag: heroTag))
          .then((val) {
        _conCart.listenForCarts();
        setState(() {});
      });
    } else {
      this.setToCart(food);
    }
  }

  setToCart(food) {
    if (currentUser.value.apiToken == null) {
      Navigator.of(context).pushReplacementNamed("/Login");
    } else {
      _conFood.addToCart(food).whenComplete(() {
        _conCart.listenForCarts();
        Fluttertoast.showToast(
          msg: S.of(context).this_food_was_added_to_cart,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 6,
        );
      });
    }
  }
}
