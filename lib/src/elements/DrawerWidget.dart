import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import '../widget/drawerItem.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  ProfileController _con;
  _DrawerWidgetState() : super(ProfileController()) {
    _con = controller;
  }
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null
                  ? Navigator.of(context).pushNamed("/Settings")
                  //Navigator.of(context).pushNamed('/Profile')
                  : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
                ? Row(
                    children: [
                      Container(
                        height: 120,
                        child: Image.asset("assets/img/profil-scren-3.png"),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 70),
                              Text(currentUser.value.name,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              Text(currentUser.value.email,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                              SizedBox(height: 70)
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                // UserAccountsDrawerHeader(
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).hintColor.withOpacity(0.1),
                //   ),
                //   accountName: Text(
                //     currentUser.value.name,
                //     style: Theme.of(context).textTheme.headline6,
                //   ),
                //   accountEmail: Text(
                //     currentUser.value.email,
                //     style: Theme.of(context).textTheme.caption,
                //   ),
                //   currentAccountPicture: CircleAvatar(
                //     backgroundColor: Theme.of(context).accentColor,
                //     backgroundImage: NetworkImage(currentUser.value.image.thumb),
                //   ),
                // )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context).accentColor.withOpacity(1),
                        ),
                        SizedBox(width: 30),
                        Text(
                          S.of(context).guest,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
          ),

          if (currentUser.value.apiToken != null)
            DrawerItem(
                text: "Mon Compte",
                navigate: () => Navigator.of(context).pushNamed("/Settings")),
          DrawerItem(
              text: "Accueil",
              navigate: () => Navigator.of(context).pushNamed("/Home")),
          DrawerItem(
              text: "Restaurants",
              navigate: () => Navigator.of(context).pushNamed("/Restaurants")),
          /*    if (currentUser.value.apiToken != null)
            DrawerItem(
                text: "Plats favoris",
                navigate: () => Navigator.of(context).pushNamed("/Favorites")), */
          if (currentUser.value.apiToken != null)
            DrawerItem(
                text: "Mes commandes",
                navigate: () =>
                    Navigator.of(context).pushNamed('/Pages', arguments: 3)),
          //DrawerItem(text: "F.A.Q", navigate:() => Navigator.of(context).pushNamed("/Help")),
          if (currentUser.value.apiToken != null)
            DrawerItem(
                text: "Service Chat",
                navigate: () => Navigator.of(context).pushNamed('/Chat')),
/*           Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20),
            child: Column(
              children: [
                Divider(color: Colors.grey, thickness: 1),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Langue",
                          style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w300)),
                      Row(
                        children: [
                          Text("Français",
                              style: TextStyle(color: Constants.primaryColor)),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          // Text("Arabe"),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ), */

          GestureDetector(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then(
                  (value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Pages', (Route<dynamic> route) => false,
                        arguments: 2);
                  },
                );
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
              // Navigator.of(context).pushNamed("/Logout");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Divider(color: Colors.grey, thickness: 1),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Constants.primaryColor,
                        size: 26,
                      ),
                      Text(
                          currentUser.value.apiToken != null
                              ? "Se déconnecter"
                              : "Se connecter",
                          style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => Helper.phoneLaunchUri("+212662139877"),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 10, top: 6),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  S.of(context).help__support,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: Icon(
                                    Icons.call,
                                    color: Theme.of(context).accentColor,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: 30,
                    indent: 30,
                  ),
                  ListTile(
                    // leading: Icon(Icons.help),
                    title: Center(
                      child: Text(
                          _con.appVersion != null
                              ? 'V ${_con.appVersion ?? ''} +${_con.appBuildNumber ?? ''}'
                              : '',
                          style: TextStyle(
                              // color: Constants.primaryColor,
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          // Expanded(
          //   child: Container(
          //     alignment: Alignment.bottomCenter,
          //     child: Padding(
          //       padding: const EdgeInsets.only(bottom: 32.0),
          //       child: Text(
          //           _con.appVersion != null
          //               ? 'V ${_con.appVersion ?? ''} +${_con.appBuildNumber ?? ''}'
          //               : '',
          //           style: TextStyle(
          //               color: Constants.primaryColor,
          //               fontSize: 14,
          //               fontWeight: FontWeight.w500)),
          //     ),
          //   ),
          // )
/*           ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/Home');
              },
              leading: Icon(
                Icons.home,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).home,
                      style: MenuItemTextStyle.textStyle,
                      //style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Constants.primaryColor),
                  ])), */
          // ListTile(

          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 0);
          //   },

          //   leading: Icon(
          //     Icons.notifications,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title:
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         S.of(context).notifications,
          //         style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //       ),
          //       Icon(
          //         Icons.arrow_forward_ios_rounded,
          //         color: Constants.primaryColor
          //       )
          //     ]
          //   )

          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 3);
          //   },
          //   leading: Icon(
          //     Icons.local_mall,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title:
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         S.of(context).my_orders,
          //         style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //       ),
          //       Icon(
          //         Icons.arrow_forward_ios_rounded,
          //         color: Constants.primaryColor
          //       )
          //     ]
          //   )

          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Favorites');
          //   },
          //   leading: Icon(
          //     Icons.favorite,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title:
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         S.of(context).favorite_foods,
          //         style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //       ),
          //       Icon(
          //         Icons.arrow_forward_ios_rounded,
          //         color: Constants.primaryColor
          //       )
          //     ]
          //   )

          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 4);
          //   },
          //   leading: Icon(
          //     Icons.chat,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title:
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         S.of(context).messages,
          //         style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //       ),
          //       Icon(
          //         Icons.arrow_forward_ios_rounded,
          //         color: Constants.primaryColor
          //       )
          //     ]
          //   )

          // ),
          // ListTile(
          //   dense: true,
          //   title: Text(
          //     S.of(context).application_preferences,
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          //   trailing: Icon(
          //     Icons.remove,
          //     color: Theme.of(context).focusColor.withOpacity(0.3),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Help');
          //   },
          //   leading: Icon(
          //     Icons.help,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).help__support,
          //     style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     if (currentUser.value.apiToken != null) {
          //       Navigator.of(context).pushNamed('/Settings');
          //     } else {
          //       Navigator.of(context).pushReplacementNamed('/Login');
          //     }
          //   },
          //   leading: Icon(
          //     Icons.settings,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).settings,
          //     style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Languages');
          //   },
          //   leading: Icon(
          //     Icons.translate,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).languages,
          //     style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     if (Theme.of(context).brightness == Brightness.dark) {
          //       setBrightness(Brightness.light);
          //       setting.value.brightness.value = Brightness.light;
          //     } else {
          //       setting.value.brightness.value = Brightness.dark;
          //       setBrightness(Brightness.dark);
          //     }
          //     setting.notifyListeners();
          //   },
          //   leading: Icon(
          //     Icons.brightness_6,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
          //     style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     if (currentUser.value.apiToken != null) {
          //       logout().then((value) {
          //         Navigator.of(context).pushNamedAndRemoveUntil('/Pages', (Route<dynamic> route) => false, arguments: 2);
          //       });
          //     } else {
          //       Navigator.of(context).pushNamed('/Login');
          //     }
          //   },
          //   leading: Icon(
          //     Icons.exit_to_app,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     currentUser.value.apiToken != null ? S.of(context).log_out : S.of(context).login,
          //     style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // currentUser.value.apiToken == null
          //     ? ListTile(
          //         onTap: () {
          //           Navigator.of(context).pushNamed('/SignUp');
          //         },
          //         leading: Icon(
          //           Icons.person_add,
          //           color: Theme.of(context).focusColor.withOpacity(1),
          //         ),
          //         title: Text(
          //           S.of(context).register,
          //           style: MenuItemTextStyle.textStyle,
          //         // style: Theme.of(context).textTheme.subtitle1,
          //         ),
          //       )
          //     : SizedBox(height: 0),
          // setting.value.enableVersion
          //     ? ListTile(
          //         dense: true,
          //         title: Text(
          //           S.of(context).version + " " + setting.value.appVersion,
          //           style: Theme.of(context).textTheme.bodyText2,
          //         ),
          //         trailing: Icon(
          //           Icons.remove,
          //           color: Theme.of(context).focusColor.withOpacity(0.3),
          //         ),
          //       )
          //     : SizedBox(),
        ],
      ),
    );
  }
}
