import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../constant.dart';
import '../store/refresh_model.dart';

class BottomBarWebili extends StatelessWidget {
  const BottomBarWebili({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RefreshModel>(
        builder: (context, child, model) {
      return BottomAppBar(
        color: Colors.white,
        elevation: 5,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 0),
              child: IconButton(
                icon: Icon(Icons.favorite,
                    size: 32, color: Theme.of(context).disabledColor),
                onPressed: () {
                  Navigator.of(context).pushNamed('/Pages', arguments: 3);
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
            //   child: FlatButton(
            //     onPressed: () {
            //       Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => ChatWidget()
            //             )
            //           );
            //     },
            //     child:Stack(
            //       alignment: AlignmentDirectional.bottomEnd,
            //       children: <Widget>[
            //           Image.asset(
            //             "assets/img/icon-support-scren-4.png",
            //             height: 55,
            //           ),
            //         ]
            //       ),
            //   )
            // ),
          ],
        ),
      );
    });
  }
}

class BottomBarTracking extends StatelessWidget {
  const BottomBarTracking({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Constants.primaryColor,
                  child: Image.asset(
                    "assets/img/profil-icon-.png",
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10),
                  child: Container(
                    color: Colors.transparent,
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nom & Prenom',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 10),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.star,
                                  color: Constants.primaryColor, size: 14),
                              Icon(Icons.star,
                                  color: Constants.primaryColor, size: 14),
                              Icon(Icons.star,
                                  color: Constants.primaryColor, size: 14),
                              Icon(Icons.star,
                                  color: Constants.primaryColor, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.call_outlined, color: Constants.primaryColor),
                SizedBox(width: 10),
                Icon(Icons.message_outlined, color: Constants.primaryColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 0),
            child: Container(
              child: Image.asset(
                "assets/img/icon-support-scren-4.png",
                height: 55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
