import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constant.dart';
import '../../controllers/restaurant_controller.dart';
import '../../models/food.dart';
import '../../models/route_argument.dart';

class FoodItemWidget extends StatelessWidget {
  final String rawSvg;
  final String heroTag;
  final Food food;
  final RestaurantController restaurant;
  final bool withRestaurent;
  final bool parent;
  final bool closed;

  const FoodItemWidget(
      {Key key,
      this.restaurant,
      this.food,
      this.heroTag,
      this.withRestaurent,
      this.parent,
      this.closed,
      this.rawSvg =
          '''<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd"></path></svg>'''})
      : super(key: key);

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
          if (parent == null)
            Navigator.of(context).pushNamed('/Food',
                arguments: RouteArgument(id: food.id, heroTag: this.heroTag));
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
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
            ),
            SizedBox(width: 10),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(children: [
                              Text(
                                food.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text("Prix " + food.price.toString() + "0Dhs",
                                  style: Theme.of(context).textTheme.bodyText2),
                              IconButton(
                                onPressed: () {
                                  if (closed) {
                                    openDialogText(context, "Fermé",
                                        food.restaurant.start_time);
                                  } else {
                                    if (parent == null)
                                      Navigator.of(context).pushNamed('/Food',
                                          arguments: RouteArgument(
                                              id: food.id,
                                              heroTag: this.heroTag));
                                  }
                                },
                                icon: Icon(
                                  Icons.add_circle_rounded,
                                  size: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ])),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            food.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        this.withRestaurent != null
                            ? Text(
                                food.restaurant.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            : Text(""),
                        Text(
                          food.extras.map((e) => e.name).toList().join(', '),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
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
