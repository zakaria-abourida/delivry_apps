import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/cuisine.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CuisinesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Cuisine cuisine;
  CuisinesCarouselItemWidget({Key key, this.marginLeft, this.cuisine}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Cuisine', arguments: RouteArgument(id: cuisine.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: cuisine.id,
            child: Container(
              margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 7.0)]
                  ),
              child: 
            ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child:Padding(
                padding: const EdgeInsets.all(0),
                child: cuisine.image.url.toLowerCase().endsWith('.svg')
                    ? SvgPicture.network(
                        cuisine.image.url,
                        color: Theme.of(context).accentColor,                        
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: cuisine.image.thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              ),
            ),
            ),
          ),
         
          SizedBox(height: 5),
          Container(
            margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
            child: Text(
              cuisine.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
