import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/restaurant.dart';

class RestoPromo extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;
  final String time = "20-30 min";

  const RestoPromo({Key key, this.restaurant = null, this.heroTag = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      color: Colors.white,
      height: 100,
      width: MediaQuery.of(context).size.width / 1.3,
      child: Column(
        children: [
          // THIS WHERE IMAGE OF RESTORANT AND PROMO EXISTE
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
                    height: 125,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: restaurant.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 125,
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
                        width: 12,
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2, top: 3),
                        child: Text(
                          restaurant.deliveryFee.toString() + '0 MAD',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 10),
                        ),
                      )
                    ])
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

    // print(now.isAfter(close));
    // print(close);
    // print(now);
    // print(open);
    // print(now.isBefore(open));

    bool closed = (now.isBefore(open) || now.isAfter(close));

    // print('here ' + closed.toString());
    return closed;
  }
}
