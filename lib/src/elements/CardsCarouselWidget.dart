import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';
import '../controllers/cart_controller.dart';
import '../elements/CardsCarouselLoaderWidget.dart';
import '../helpers/vdialog.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart' as userRepo;
import '../widget/RestoItem.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  List<Restaurant> restaurantsList;
  String heroTag;

  CartController cart = new CartController();
  CardsCarouselWidget(
      {Key key, this.parentScaffoldKey, this.restaurantsList, this.heroTag})
      : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  Vdialog vdialog = new Vdialog();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.restaurantsList.isEmpty
        ? CardsCarouselLoaderWidget()
        : Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Color(0xFFECEFF1),
                  height: 2,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                );
              },
              itemCount: widget.restaurantsList.length,
              itemBuilder: (context, index) {
                // print(widget.restaurantsList..elementAt(index).toMap());
                return GestureDetector(
                    onTap: () {
                      if (!_isClosed(index)) {
                        //openDialogText(context,"Fermé", widget.restaurantsList.elementAt(index).start_time);
                        //vdialog.pop(context,'Le restaurant est fermé !');
                        Navigator.of(context).pushNamed('/Details',
                            arguments: RouteArgument(
                              id: '0',
                              param: widget.restaurantsList.elementAt(index).id,
                              heroTag: widget.heroTag,
                            ));
                      }
                    },
                    child: RestoItem(
                        restaurant: widget.restaurantsList.elementAt(index),
                        heroTag: widget.heroTag)
                    //CardWidget(restaurant: widget.restaurantsList.elementAt(index), heroTag: widget.heroTag),
                    );
              },
            ));
  }

  _isClosed(index) {
    if (userRepo.currentUser.value.id == "150") return false;

    var restaurant = widget.restaurantsList.elementAt(index);

    if (restaurant.start_time == null || restaurant.end_time == null)
      return true;

    DateFormat dateFormat = new DateFormat.Hm();
    DateTime now = DateTime.now();

    DateTime open = dateFormat.parse(restaurant.start_time);
    open = new DateTime(now.year, now.month, now.day, open.hour, open.minute);

    DateTime close = dateFormat.parse(restaurant.end_time);
    close =
        new DateTime(now.year, now.month, now.day, close.hour, close.minute);

    bool closed = (now.isBefore(open) || now.isAfter(close));

    return closed;
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
