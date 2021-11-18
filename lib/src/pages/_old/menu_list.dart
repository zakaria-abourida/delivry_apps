import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// import 'package:expansion_card/expansion_card.dart';
import '../../../constant.dart';
import '../../controllers/restaurant_controller.dart';
import '../../elements/CircularLoadingWidget.dart';
import '../../elements/DrawerWidget.dart';
import '../../elements/FoodItemWidget.dart';
import '../../models/food.dart';
import '../../models/restaurant.dart';
import '../../models/route_argument.dart';
import '../../repository/user_repository.dart';
import '../../widget/AppBarWebili.dart';
import '../../widget/BottomBar.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;
  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  RestaurantController _con;
  String restaurant_name = null;
  bool closed = false;
  List<String> selectedCategories;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var category;
  final String time = "20-30 min";

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
    _con.restaurant = widget.routeArgument.param as Restaurant;
    // _con.listenForTrendingFoods(_con.restaurant.id);
    _con.listenForCategories(_con.restaurant.id);
    this.restaurant_name = _con.restaurant.name;
    super.initState();

    Timer(Duration(seconds: 3), () {
      _con.listenForFoods(_con.restaurant.id);
      // _con.listenForFoods(_con.restaurant.id, categoriesId: [_con.categories.elementAt(0).id]);
      // selectedCategories = [_con.categories.elementAt(0).id];
      setState(() {
        if (currentUser.value.id == "150") {
          this.closed = false;
        } else {
          this.closed = _isClosed();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBarWebili(),
      appBar: AppBarWebili(parentScaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Padding(

            //   padding: const EdgeInsets.symmetric(horizontal: 20),

            //   child: SearchBarWidget(restaurant_id : _con.restaurant.id, step : "menu"),

            // ),

            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   leading: Icon(
            //     Icons.bookmark,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Text(
            //     S.of(context).featured_foods,
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   subtitle: Text(
            //     S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
            //     maxLines: 2,
            //     style: Theme.of(context).textTheme.caption,
            //   ),
            // ),

            // FoodsCarouselWidget(heroTag: 'menu_trending_food', foodsList: _con.trendingFoods),

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
              title: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text(
                        _con.restaurant.name,
                        style: TextStyle(
                            color: Constants.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
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
                    ]),
                    Column(children: [
                      rating(),
                    ]),
                  ],
                ),
                SizedBox(height: 2),
                Row(children: [
                  _con.restaurant.description != null
                      ? Text(
                          _con.restaurant.description,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.normal),
                        )
                      : Text("")
                ]),
              ]),
              // subtitle: Text(
              //   S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
              //   maxLines: 2,
              //   style: Theme.of(context).textTheme.caption,
              // ),
            ),

            // _con.categories.isEmpty
            //     ? SizedBox(height: 90)
            //     : Container(
            //         height: 90,
            //         child: ListView(
            //           primary: false,
            //           shrinkWrap: true,
            //           scrollDirection: Axis.horizontal,
            //           children: List.generate(_con.categories.length, (index) {

            //             var _category = _con.categories.elementAt(index);
            //             var _selected = this.selectedCategories != null ? this.selectedCategories.contains(_category.id) : false;

            //             return Padding(
            //               padding: const EdgeInsetsDirectional.only(start: 20),
            //               child: RawChip(
            //                 elevation: 0,
            //                 label: Text(_category.name),
            //                 labelStyle: _selected
            //                     ? Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor))
            //                     : Theme.of(context).textTheme.bodyText2,
            //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            //                 backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
            //                 selectedColor: Theme.of(context).accentColor,
            //                 selected: _selected,
            //                 //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
            //                 showCheckmark: false,
            //                 avatar: (_category.id == '0')
            //                     ? null
            //                     : (_category.image.url.toLowerCase().endsWith('.svg')
            //                         ? SvgPicture.network(
            //                             _category.image.url,
            //                             color: _selected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
            //                           )
            //                         : CachedNetworkImage(
            //                             fit: BoxFit.cover,
            //                             imageUrl: _category.image.icon,
            //                             placeholder: (context, url) => Image.asset(
            //                               'assets/img/loading.gif',
            //                               fit: BoxFit.cover,
            //                             ),
            //                             errorWidget: (context, url, error) => Icon(Icons.error),
            //                           )
            //                         ),
            //                 onSelected: (bool value) {

            //                   setState(() {

            //                     if (_category.id == '0') {
            //                       this.selectedCategories = ['0'];
            //                     } else {
            //                       this.selectedCategories.removeWhere((element) => element == '0');
            //                     }

            //                     if (value) {
            //                       // this.selectedCategories.add(_category.id);
            //                       this.selectedCategories = [_category.id];
            //                     } else {
            //                       this.selectedCategories.removeWhere((element) => element == _category.id);
            //                     }

            //                     _con.selectCategory(this.selectedCategories);

            //                   });

            //                 },

            //               ),
            //             );
            //           }),
            //         ),
            //       ),
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
                              width: 18,
                              height: 18,
                            ),
                            Text(
                              _con.restaurant.deliveryFee.toString() + ' MAD',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 12),
                            ),
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
                                  fontSize: 14, fontWeight: FontWeight.bold),
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
    );
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
                        closed: this.closed);
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
        );
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

    // print(now.isAfter(close));
    // print(close);
    // print(now);
    // print(open);
    // print(now.isBefore(open));

    bool closed = (now.isBefore(open) || now.isAfter(close));

    // print('here ' + closed.toString());
    return closed;
  }
}
