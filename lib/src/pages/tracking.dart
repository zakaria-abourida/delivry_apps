import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/tracking_controller.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constant.dart';

class TrackingWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TrackingController _con;
  TabController _tabController;
  int _tabIndex = 0;
  String _mapStyle;

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
  }

  @override
  void initState() {
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    //connectToServer(currentUser.value.id,currentUser.value.apiToken);
    super.initState();
    changeMapMode();
    _con.listenForOrder(orderId: widget.routeArgument.id);
  }

  void dispose() {
    _con.orderStatusTimer?.cancel();
    _con.driverLocationTimer?.cancel();
    _tabController.dispose();
    _con.mapController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(33.5803431, -7.607646),
      zoom: 10);

  Future<void> changeMapMode() async {
    await rootBundle
        .loadString("assets/json/mapsStyle.json")
        .then((mapStyle) => _mapStyle = mapStyle);
  }

  void setMapStyle(String mapStyle) {
    _con.mapController.setMapStyle(mapStyle);
  }

  setOrdersStatusText() {
    if (_con.isDriverArrived)
      return Text(
        'Votre livreur est arrivé chez vous',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 25),
      );
    switch (_con.order.orderStatus.id) {
      case "1":
        return Text(
          'Votre commande a été acceptée',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 25),
        );
        break;
      case "2":
        return Text(
          'Votre commande est en cours de préparation',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 25),
        );
        break;

      case "3":
        return Text(
          'Votre commande a été récuperée',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 25),
        );
        break;

      case "4":
        return Text(
          'Votre livreur est en route',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 25),
        );
        break;

      // case "4":
      //   return Text(
      //     'Votre livreur est arrivé',
      //     style: TextStyle(color: Colors.grey, fontSize: 25),
      //   );
      //   break;

      default:
        Text(
          'Commande livrée',
          style: TextStyle(color: Colors.grey, fontSize: 25),
        );
        ;
        break;
    }
  }

  setOrderStatus() {
    if (_con.isDriverArrived)
      return Image.asset(
        "assets/img/4.png",
        fit: BoxFit.fitWidth,
      );
    switch (_con.order.orderStatus.id) {
      case "2":
        return Image.asset(
          "assets/img/1.png",
          fit: BoxFit.fitWidth,
        );
        break;

      case "3":
        return Image.asset(
          "assets/img/2.png",
          fit: BoxFit.fitWidth,
        );
        break;
      case "4":
        return Image.asset(
          "assets/img/3.png",
          fit: BoxFit.fitWidth,
        );
        break;

      default:
        Text('');
        break;
    }
  }

  setOrderTime() {
    if (_con.isDriverArrived)
      return Text('00', style: TextStyle(fontSize: 25, color: Colors.grey));

    if (_con.distance != null)
      return Text(_con.calculateTimeByDistance(),
          style: TextStyle(fontSize: 25, color: Colors.grey));
    else
      return Text('...', style: TextStyle(fontSize: 25, color: Colors.grey));
  }

  void _onMapCreated(GoogleMapController controller) {
    _con.mapController = controller;
    _con.controller.complete(controller);
    _con.mapController.setMapStyle(_mapStyle);
    _con.setPolyLines();
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: _con.order == null || _con.orderStatus.isEmpty
          ? Container(
              height: 1,
            )
          : (_con.order.orderStatus.id == "5"
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 135,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.15),
                            offset: Offset(0, -2),
                            blurRadius: 5.0)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(S.of(context).how_would_you_rate_this_restaurant,
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(height: 5),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Reviews',
                              arguments: RouteArgument(
                                  id: _con.order.id,
                                  heroTag: "restaurant_reviews"));
                        },
                        padding: EdgeInsets.symmetric(vertical: 5),
                        shape: StadiumBorder(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: Helper.getStarsList(
                              double.parse(_con
                                  .order.foodOrders[0].food.restaurant.rate),
                              size: 35),
                        ),
                      ),
                    ],
                  ))
              : Text("") //BottomBarTracking()
          ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).tracking_order,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        // actions: <Widget>[
        //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        // ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: (size.height - appBarHeight) * 0.35,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) =>
                  _onMapCreated(controller),
              markers: Set.from(_con.allMarkers),
              polylines: _con.polyLines,
            ),
          ),
          _buildBottomSection(size, appBarHeight)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _con.driverInfo != null
          ? Container(
              height: 120,
              width: size.width,
              padding: EdgeInsets.only(left: 42, bottom: 12),
              alignment: Alignment.bottomCenter,
              child: _buildDriverInfoWidget(),
            )
          : Container(
              height: 50,
              width: 50,
            ),
    );
  }

  _buildBottomSection(Size size, double appBarHeight) {
    return Expanded(
      child: Container(
        height: (size.height - appBarHeight) * 0.65,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _con.order == null || _con.orderStatus.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Constants.primaryColor),
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Constants.primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setOrderTime(),
                            Text('min',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(child: setOrdersStatusText()),
                  SizedBox(height: 20),
                  Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: setOrderStatus()),
                ],
              ),
      ),
    );
  }

  _buildDriverInfoWidget() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Contact du livreur ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Image.asset(
                    'assets/img/user.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_con.driverInfo.name}',
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                    SizedBox(height: 2),
                    if (_con.driverInfo.phone != null)
                      GestureDetector(
                        onTap: () => _con.callDriver(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Constants.primaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text('${_con.driverInfo.phone}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.primaryColor)),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            if (_con.driverInfo.rating.round() > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: List.generate(
                          _con.driverInfo.rating.round(),
                          (index) => Icon(
                                Icons.star_rate_rounded,
                                color: Constants.primaryColor,
                                size: 11,
                              ))),
                ],
              )
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/Help'),
            child: Image.asset(
              'assets/img/icon-support-scren-4.png',
              fit: BoxFit.cover,
              height: 60,
              width: 60,
            ),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
