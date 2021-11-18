import 'package:flutter/material.dart';

import '../models/cuisine.dart';
import 'CircularLoadingWidget.dart';
import 'CuisinesCarouselItemWidget.dart';

// ignore: must_be_immutable
class CuisinesCarouselWidget extends StatelessWidget {
  List<Cuisine> cuisines;

  CuisinesCarouselWidget({Key key, this.cuisines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.cuisines.isEmpty
        ? CircularLoadingWidget(height: 0)
        : Container(
            height: 105,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: this.cuisines.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 15 : _marginLeft = 0;
                return new CuisinesCarouselItemWidget(
                  marginLeft: _marginLeft,
                  cuisine: this.cuisines.elementAt(index),
                );
              },
            ));
  }
}
