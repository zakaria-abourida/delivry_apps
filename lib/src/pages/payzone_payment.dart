import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/zoning_fields.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../generated/l10n.dart';
import '../controllers/payzone_controller.dart';
import '../helpers/vdialog.dart';
import '../models/courier_order.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class PayZonePaymentWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Vdialog vdialog = new Vdialog();
  final ZoningFields zoningFields;
  final String restaurantId;

  PayZonePaymentWidget(
      {Key key, this.routeArgument, this.zoningFields, this.restaurantId})
      : super(key: key);
  @override
  _PayZonePaymentWidgetState createState() => _PayZonePaymentWidgetState();
}

class _PayZonePaymentWidgetState extends StateMVC<PayZonePaymentWidget> {
  PayZoneController _con;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  _PayZonePaymentWidgetState() : super(PayZoneController()) {
    log('init PayZonePaymentWidget');
    _con = controller;
  }

  @override
  void initState() {
    if (widget.routeArgument != null) {
      _con.isCourierOrder = widget.routeArgument?.id == 'courier';
      _con.courierOrder = widget.routeArgument?.param as CourierOrder;
    }
    if (widget.zoningFields != null) _con.zoningFields = widget.zoningFields;
    _con.restaurantId = widget.restaurantId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).card_payment,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      floatingActionButton: favoriteButton(),
      body: Stack(
        children: <Widget>[
          WebView(
              initialUrl: _con.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _con.webView = controller;
              },
              // onPageStarted: (String url) {
              //   setState(() {
              //     _con.url = url;
              //   });
              //   if (url == "${GlobalConfiguration().get('base_url')}payments/payzone") {
              //     Navigator.of(context).pushReplacementNamed('/Pages', arguments: 3);
              //   }
              // },
              onPageFinished: (String url) {
                log('onPageFinished url $url');
                if (url.contains('redirect_done')) {
                  log('navigate to /CashOnDelivery');
                  Navigator.of(context).pushReplacementNamed("/CashOnDelivery",
                      arguments: RouteArgument(param: widget.zoningFields));
                  // Navigator.of(context).pushNamed('/Home');

                  // _con.checkTransation().then((value) => value
                  //     ? Navigator.of(context).pushNamed('/Home', arguments: new RouteArgument(param: {"alert": true}))
                  //     : Navigator.of(context).pushNamed('/Home', arguments: new RouteArgument(param: {"alert": false}))
                  //  );
                }

                setState(() {
                  _con.progress = 1;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => OrderSuccessWidget(routeArgument: widget.routeArgument)
                  //     )
                  // );
                });
              }),
          _con.progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              child: const Icon(Icons.ac_unit),
            );
          }
          return Container();
        });
  }
}
