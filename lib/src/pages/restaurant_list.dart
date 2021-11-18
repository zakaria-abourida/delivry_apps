import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../controllers/restaurant_list_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CuisinesCarouselWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../widget/RestoPromo.dart';

class RestaurantListWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  RestaurantListWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  RestaurantListWidgetState createState() => RestaurantListWidgetState();
}

class RestaurantListWidgetState extends StateMVC<RestaurantListWidget> {
  RestaurantListController _con;
  bool isLoading = false;
  int page = 0;
  DateTime currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  RestaurantListWidgetState() : super(RestaurantListController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      page = 0;
      print(page);
    });
    _con.refreshRestaurantList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              color: Colors.white,
              icon: Icon(Icons.person),
              iconSize: 35,
            )
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              color: Colors.white,
              // Within the SecondRoute widget
              onPressed: () {
                // DateTime now = DateTime.now();
                // if (currentBackPressTime == null ||
                //     now.difference(currentBackPressTime) >
                //         Duration(seconds: 2)) {
                //   currentBackPressTime = now;
                //   Fluttertoast.showToast(
                //       msg: S.of(context).tapAgainToGetBackToMainMenu);
                //   return Future.value(false);
                // }
                Navigator.of(context).pushReplacementNamed('/Home');
                // return Future.value(true);
              }),
          backgroundColor: Constants.primaryColor,
          centerTitle: true,
          title: Image.asset(
            'assets/img/logo.png',
            fit: BoxFit.fitHeight,
            height: 130,
            color: Colors.white,
          ),
          elevation: 0,
        ),
        //bottomNavigationBar: BottomBarWebili(),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // print("onNotification");
            if (isLoading == false &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              // print("scroller");

              setState(() {
                isLoading = true;
                page++;
              });

              _loadData();
            }
          },
          child: RefreshIndicator(
            onRefresh: _con.refreshRestaurantList,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                    settingsRepo.setting.value.homeSections.length, (index) {
                  String _homeSection =
                      settingsRepo.setting.value.homeSections.elementAt(index);
                  switch (_homeSection) {
                    case 'search':
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SearchBarWidget(
                              onClickFilter: (event) {
                                _scaffoldKey.currentState.openEndDrawer();
                              },
                              step: "restaurant_only"),
                        ),
                        _con.cuisines.isEmpty
                            ? Text('')
                            : CuisinesCarouselWidget(
                                cuisines: _con.cuisines,
                                key: widget.parentScaffoldKey),
                        const Divider(
                          color: Color(0xFFECEFF1),
                          height: 2,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ]);

                    case 'top_restaurants':
                      return Column(children: [
                        SizedBox(height: 10),
                        !_con.promotions.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 10),
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage('assets/img/promo.png'),
                                      width: 14,
                                      height: 14,
                                    ),
                                    Text(
                                      " Promotions :",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ))
                            : Text(''),
                        SizedBox(height: 4),
                        promotions(),
                        _con.promotions.isEmpty
                            ? SizedBox(height: 0)
                            : const Divider(
                                color: Color(0xFFECEFF1),
                                height: 2,
                                thickness: 2,
                                indent: 20,
                                endIndent: 20,
                              ),
                        CardsCarouselWidget(
                            parentScaffoldKey: widget.parentScaffoldKey,
                            restaurantsList: _con.topRestaurants,
                            heroTag: 'home_top_restaurants'),
                        Container(
                          height: isLoading ? 50.0 : 0,
                          color: Colors.transparent,
                          child: Center(
                            child: new CircularProgressIndicator(),
                          ),
                        )
                      ]);

                    default:
                      return SizedBox(height: 0);
                  }
                }),
              ),
            ),
          ),
        )
        // onWillPop: () async {
        //   DateTime now = DateTime.now();
        //   if (currentBackPressTime == null ||
        //       now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        //     currentBackPressTime = now;
        //     Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
        //     return Future.value(false);
        //   }
        //   Navigator.of(context).pushReplacementNamed('/Home');
        //   return Future.value(true);
        // },
        );
  }

  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));
    // update data and loading status
    setState(() {
      _con.listenForTopRestaurants(page);
      //Load restaurants
      isLoading = false;
    });
  }

  promotions() {
    return _con.promotions.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 150,
            child: ListView(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(_con.promotions.length, (index) {
                var _promotion = _con.promotions.elementAt(index);
                return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 5),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/Details',
                              arguments: RouteArgument(
                                id: '0',
                                param: _promotion.id,
                                heroTag: "home_promotions",
                              ));
                        },
                        child: RestoPromo(
                            restaurant: _promotion, heroTag: "home_promotions")
                        //CardWidget(restaurant: widget.restaurantsList.elementAt(index), heroTag: widget.heroTag),
                        ));
              }),
            ),
          );
  }
}
