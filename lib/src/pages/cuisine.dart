import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cuisine_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';

class CuisineWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CuisineWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CuisineWidgetState createState() => _CuisineWidgetState();
}

class _CuisineWidgetState extends StateMVC<CuisineWidget> {
  // TODO add layout in configuration file
  String layout = 'list';

  CuisineController _con;

  _CuisineWidgetState() : super(CuisineController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForRestaurantsByCuisine(id: widget.routeArgument.id);
    _con.listenForCuisine(id: widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      //drawer: DrawerWidget(),
      // endDrawer: FilterWidget(onFilter: (filter) {
      //   Navigator.of(context).pushReplacementNamed('/Cuisine', arguments: RouteArgument(id: widget.routeArgument.id));
      // }),
      appBar: AppBar(
         leading: IconButton(
            onPressed: () {
             
                Navigator.pop(context);
              
            },
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: Theme.of(context).hintColor,
          ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).cuisines,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        // actions: <Widget>[
        //   _con.loadCart
        //       ? Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 15),
        //           child: SizedBox(
        //             width: 26,
        //             child: CircularProgressIndicator(
        //               strokeWidth: 2.5,
        //             ),
        //           ),
        //         )
        //       : ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCuisine,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: SearchBarWidget(onClickFilter: (filter) {
              //     _con.scaffoldKey?.currentState?.openEndDrawer();
              //   }),
              // ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _con.cuisine?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  // trailing: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: <Widget>[
                  //     IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           this.layout = 'list';
                  //         });
                  //       },
                  //       icon: Icon(
                  //         Icons.format_list_bulleted,
                  //         color: this.layout == 'list' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                  //       ),
                  //     ),
                  //     // IconButton(
                  //     //   onPressed: () {
                  //     //     setState(() {
                  //     //       this.layout = 'grid';
                  //     //     });
                  //     //   },
                  //     //   icon: Icon(
                  //     //     Icons.apps,
                  //     //     color: this.layout == 'grid' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                  //     //   ),
                  //     // )
                  //   ],
                  // ),
             
                ),
              ),
           
              _con.restaurants.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : CardsCarouselWidget(
                            parentScaffoldKey:_con.scaffoldKey,
                            restaurantsList: _con.restaurants,
                            heroTag: 'restaurants_by_cuisine'
                          )
                       
               ],
          ),
       
        ),
      ),
    );
  }
}
