import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../constant.dart';
import '../../controllers/reviews_controller.dart';
import '../../helpers/helper.dart';
import '../../models/route_argument.dart';
import '../../models/user.dart';
import '../../widget/AppBarWebili.dart';

class CourierReviews extends StatefulWidget {
  final RouteArgument routeArgument;

  const CourierReviews({Key key, this.routeArgument}) : super(key: key);

  @override
  _CourierReviewsState createState() => _CourierReviewsState();
}

class _CourierReviewsState extends StateMVC<CourierReviews> {
  String orderId;
  User driverInfo;
  ReviewsController _con;
  _CourierReviewsState() : super(ReviewsController()) {
    _con = controller;
  }

  @override
  void initState() {
    orderId = widget.routeArgument.id;
    driverInfo = widget.routeArgument.param as User;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE82D86),
      appBar: AppBarWebili(
        bgColor: "grey",
        showActionIcon: false,
        showLeading: false,
      ),
      body: Container(
        //padding: EdgeInsets.fromLTRB(16, 60, 16, 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Commande livrée",
                      style: Constants.courierPrimaryText
                          .copyWith(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Image.asset(
                'assets/img/drv.png',
                fit: BoxFit.scaleDown,
                scale: 7,
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                                child: Text(
                              "${Helper.splitName(driverInfo?.name ?? '')}",
                              style: Constants.courierPrimaryText.copyWith(
                                  color: Constants.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200),
                            )),
                            radius: 32,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "NOTEZ LE LIVREUR",
                                style: Constants.courierPrimaryText.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _con.deliveryManReview.rate =
                                            (index + 1).toString();
                                      });
                                    },
                                    child: index <
                                            int.parse(
                                                _con.deliveryManReview.rate)
                                        ? Icon(Icons.grade,
                                            size: 28, color: Colors.white)
                                        : Icon(Icons.grade_outlined,
                                            size: 28, color: Colors.white),
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushReplacementNamed('/Home'),
                        //_con.addDeliveryManReview(_con.deliveryManReview, isCourier: true),
                        child: Text(
                          "Passer",
                          style: Constants.courierPrimaryText
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
