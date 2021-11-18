import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';
import '../models/restaurant.dart';

class RestoItem extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;
  final String time = "20-30 min";

  const RestoItem({Key key, this.restaurant = null, this.heroTag = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    rating() {
      List<Widget> listWidget = new List<Widget>();

      for (int i = 0; i < double.parse(this.restaurant.rate).toInt(); i++) {
        listWidget.add(new Icon(
          Icons.star,
          color: Constants.primaryColor,
          size: 14,
        ));
      }
      for (int i = 0; i < 5 - double.parse(this.restaurant.rate).toInt(); i++) {
        listWidget.add(new Icon(
          Icons.star,
          color: Colors.grey.shade700,
          size: 14,
        ));
      }
      return Row(children: listWidget);
    }

    return Container(
      padding: EdgeInsets.only(right: 15, left: 15),
      color: Colors.white,
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //Row of Title and Start
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(
                  restaurant.name,
                  style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5),
                  child: Row(children: [
                    Icon(
                      Icons.alarm_outlined,
                      size: 10,
                    ),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ])),
            ],
          ),

          // THIS WHERE IMAGE OF RESTAURANT AND PROMO EXISTE
          Stack(
            children: [
              Hero(
                tag: this.heroTag != null
                    ? this.heroTag + restaurant.id
                    : restaurant.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: restaurant.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              _isClosed()
                  ? Positioned(
                      child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child:
                          Image.asset("assets/img/ferme.png", fit: BoxFit.fill),
                    ))
                  : Text('')
            ],
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Row(children: [
                      Image(
                        image: AssetImage('assets/img/moto.png'),
                        width: 14,
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2, top: 3),
                        child: Text(
                          restaurant.deliveryFee.toString() + '0 MAD',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      )
                    ])
                  ]),
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2, top: 3),
                      child: rating(),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _isClosed() {
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

    // print('here ' + closed.toString());
    return closed;
  }
}
