import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../generated/l10n.dart';
import '../controllers/search_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../models/route_argument.dart';
import '../widget/RestoItem.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;
  final String step; //from where the search was triggered restaurant or food
  final String restaurant_id;
  SearchResultWidget({Key key, this.heroTag, this.step, this.restaurant_id})
      : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  SearchController _con;
  var visiblePercentage = 100.00;
  _SearchResultWidgetState() : super(SearchController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.of(context).search,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).ordered_by_nearby_first,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (text) {
                if (widget.step == "menu")
                  _con.refreshFoodSearchByRestaurant(
                      text, widget.restaurant_id);
                else if (widget.step == "restaurant_only")
                  _con.refreshSearchByRestaurant(text);
                else
                  _con.refreshSearch(text);

                //_con.saveSearch(text);
              },
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: S.of(context).search_for_restaurants_or_foods,
                hintStyle: Theme.of(context)
                    .textTheme
                    .caption
                    .merge(TextStyle(fontSize: 14)),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          (_con.restaurants.isEmpty && _con.foods.isEmpty)
              ? Expanded(
                  child: ListView(children: <Widget>[
                  VisibilityDetector(
                    key: Key('my-widget-key'),
                    onVisibilityChanged: (visibilityInfo) {
                      setState(() {
                        this.visiblePercentage =
                            visibilityInfo.visibleFraction * 100;
                      });
                      // debugPrint(
                      //     'Widget ${visibilityInfo.key} is ${this.visiblePercentage}% visible');
                    },
                    child: CircularLoadingWidget(height: 288),
                  ),
                  this.visiblePercentage == 0 &&
                          _con.restaurants.isEmpty &&
                          _con.foods.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 70, right: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              S.of(context).nothing_found,
                              // Oops, recherche introuvable
                              // 'Oops, Nothing found !',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        )
                      : Text(""),
                ]))
              : (widget.step == "restaurant_only"
                  ? Expanded(
                      child: ListView(
                        children: <Widget>[
                          //Meals
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 20, right: 20),
                          //   child: ListTile(
                          //     dense: true,
                          //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                          //     title: Text(
                          //       S.of(context).foods_results,
                          //       style: Theme.of(context).textTheme.subtitle1,
                          //     ),
                          //   ),
                          // ),
                          // ListView.separated(
                          //   scrollDirection: Axis.vertical,
                          //   shrinkWrap: true,
                          //   primary: false,
                          //   itemCount: _con.foods.length,
                          //   separatorBuilder: (context, index) {
                          //     return SizedBox(height: 10);
                          //   },
                          //   itemBuilder: (context, index) {
                          //     return FoodItemWidget(
                          //         heroTag: 'search_list',
                          //         food: _con.foods.elementAt(index),
                          //         withRestaurent: true);
                          //   },
                          // ),

                          //Restaurants
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              title: Text(
                                S.of(context).restaurants_results,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.restaurants.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/Details',
                                        arguments: RouteArgument(
                                          id: '0',
                                          param: _con.restaurants
                                              .elementAt(index)
                                              .id,
                                          heroTag: widget.heroTag,
                                        ));
                                  },
                                  child: RestoItem(
                                      restaurant:
                                          _con.restaurants.elementAt(index),
                                      heroTag: widget.heroTag));
                            },
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        children: <Widget>[
                          //Meals
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              title: Text(
                                S.of(context).foods_results,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),

                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.foods.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              return FoodItemWidget(
                                  heroTag: 'search_list',
                                  food: _con.foods.elementAt(index),
                                  withRestaurent: true);
                            },
                          ),
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}
