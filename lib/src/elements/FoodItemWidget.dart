import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../constant.dart';
import '../controllers/restaurant_controller.dart';
import '../models/food.dart';

class FoodItemWidget extends StatelessWidget {
  final String heroTag;
  final Food food;
  final RestaurantController restaurant;
  final bool withRestaurent;
  final bool parent;
  final bool closed;
  final VoidCallback pushToExtras;

  const FoodItemWidget({
    Key key,
    this.restaurant,
    this.food,
    this.heroTag,
    this.withRestaurent,
    this.parent,
    this.closed,
    this.pushToExtras,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        if (closed) {
          openDialogText(context, "Fermé", food.restaurant.start_time);
        } else {
          if (parent == null) this.pushToExtras();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            // boxShadow: [
            //   BoxShadow(
            //       color: Theme.of(context).focusColor.withOpacity(0.1),
            //       blurRadius: 5,
            //       offset: Offset(0, 2)),
            // ],
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: GestureDetector(
                  onTap: () {},
                  child: Hero(
                    tag: heroTag + food.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        imageUrl: food.image.thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )),
            ),
            SizedBox(width: 5),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          185,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 7),
                                              child: Text(
                                                food.name,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                            food.ingredients != null
                                                ? Html(
                                                    data: food.ingredients,
                                                    style: {
                                                        "*": Style(
                                                            textAlign:
                                                                TextAlign.left)
                                                      })
                                                : Text('')
                                          ])),
                                  Column(children: [
                                    Text(food.price.toString() + "0Dhs",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Icon(
                                      Icons.add_circle_rounded,
                                      size: 18,
                                      color: Theme.of(context).accentColor,
                                    )
                                  ]),
                                ])),

                        // Padding(
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Html(
                        //     data: food.ingredients,
                        //   )
                        //   //   Text(
                        //   //   food.ingredients,
                        //   //   overflow: TextOverflow.ellipsis,
                        //   //   maxLines: 1,
                        //   //   style: Theme.of(context).textTheme.bodyText2,
                        //   // ),
                        // ),

                        // this.withRestaurent != null
                        //     ? Text(
                        //         food.restaurant.name,
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 1,
                        //         style: Theme.of(context).textTheme.bodyText2,
                        //       )
                        //     : Text(""),
                        // Text(
                        //   food.extras.map((e) => e.name).toList().join(', '),
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   style: Theme.of(context).textTheme.caption,
                        // ),
                      ],
                    ),
                  ),

                  // SizedBox(width: 4),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  // children: <Widget>[
                  //   Row(children: [
                  //     Text("Prix "+food.price.toString()+"0Dhs", style: Theme.of(context).textTheme.bodyText2),
                  //     IconButton(
                  //       onPressed: () {
                  //         if (closed) {
                  //           openDialogText(context,"Fermé", food.restaurant.start_time);
                  //         }else{
                  //           if (parent == null)
                  //             Navigator.of(context).pushNamed('/Food',
                  //                 arguments: RouteArgument(id: food.id, heroTag: this.heroTag));
                  //         }
                  //       },
                  //       icon: Icon(
                  //         Icons.add_circle_rounded,
                  //         size: 14,
                  //         color:  Theme.of(context).accentColor[400],
                  //       ),
                  //     ),

                  // ),
                  // Helper.getPrice(
                  //   food.price,
                  //   context,
                  //   style: Theme.of(context).textTheme.headline1,
                  // ),
                  // food.discountPrice > 0
                  //     ? Helper.getPrice(food.discountPrice, context,
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyText2
                  //             .merge(TextStyle(
                  //                 decoration:
                  //                     TextDecoration.lineThrough)))
                  //     : SizedBox(height: 0),
                  // ])
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> openDialogText(
      BuildContext context, String text, String time) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Constants.primaryColor.withOpacity(1),
            contentPadding: EdgeInsets.all(0),
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          // Image.asset("assets/img/icons-closed.png",
                          //     height: 100, color: Colors.white),
                          // Icon(
                          //   Icons.close,
                          //   color: Colors.white,
                          // ),
                          Text(text,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27)),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Heure d'ouverture à : " + time,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          SizedBox(
                            height: 100,
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_rounded,
                          //   color: Colors.white,
                          //   size: 80,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        })) {
    }
  }
}
