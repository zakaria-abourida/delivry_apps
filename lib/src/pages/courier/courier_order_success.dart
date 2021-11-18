import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../constant.dart';
import '../../models/route_argument.dart';

class CourierOrderSuccess extends StatefulWidget {
  final RouteArgument routeArgument;
  CourierOrderSuccess({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends StateMVC<CourierOrderSuccess> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          useSafeArea: false,
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushReplacementNamed('/Home');
                return Future.value(true);
              },
              child: SizedBox.expand(
                  child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Constants.primaryColor.withOpacity(1),
                contentPadding: EdgeInsets.zero,
                content: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 80,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/img/order_success.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 40),
                            child: new Text("Voir ma commande",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            shape: StadiumBorder(),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  '/CourierTrackingOrder',
                                  arguments: RouteArgument(
                                      param: widget.routeArgument.param));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 40),
                            child: new Text("Passer",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            shape: StadiumBorder(),
                            color: Colors.transparent,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/Home');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ))));
    });
    //SchedulerBinding.instance.addPostFrameCallback((_) =>  _con.openDialogOrderSuccess(context));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/Home');
        return Future.value(true);
      },
      child: Scaffold(body: Container()),
    );
  }
}
