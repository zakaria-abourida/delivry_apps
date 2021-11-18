import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ProfileSettingsDialog.dart';
import '../repository/user_repository.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  SettingsController _con;

  _SettingsWidgetState() : super(SettingsController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.pink,
        elevation: 0,
        centerTitle: true,
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Icon(
            //   Icons.info,
            //   color: Colors.white,
            // ),
            Text(S.of(context).profile_settings,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14))
          ],
        ),
      ),
      body: currentUser.value.id == null
          ? CircularLoadingWidget(height: 500)
          : CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.pink,
                expandedHeight: 160.0,
                flexibleSpace: Container(
                  margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: FlexibleSpaceBar(
                    title: SizedBox(
                      width: 55,
                      height: 55,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(300),
                        onTap: () {
                          Navigator.of(context).pushNamed('/Profile');
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(currentUser.value.image.thumb),
                        ),
                      ),
                    ),
                    // background: FlutterLogo(),
                  ),
                ),
              ),
              SliverFillRemaining(
                  child: Column(children: <Widget>[
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   child: SearchBarWidget(),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    // decoration: BoxDecoration(
                    //   color: Theme.of(context).primaryColor,
                    //   borderRadius: BorderRadius.circular(6),
                    //   boxShadow: [
                    //     BoxShadow(
                    //         color:
                    //             Theme.of(context).hintColor.withOpacity(0.15),
                    //         offset: Offset(0, 3),
                    //         blurRadius: 10)
                    //   ],
                    // ),
                    child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            trailing: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              minWidth: 50.0,
                              height: 25.0,
                              child: ProfileSettingsDialog(
                                user: currentUser.value,
                                onChanged: () {
                                  _con.update(currentUser.value);
//                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.pink,
                                      size: 20,
                                    ),
                                    Text(
                                      S.of(context).full_name + " :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text(
                                    currentUser.value.name ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Divider(
                                  height: 20,
                                  thickness: 5,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: Colors.pink,
                                      size: 20,
                                    ),
                                    Text(
                                      S.of(context).phone + " :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Text(
                                      currentUser.value.phone ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )),
                                Divider(
                                  height: 20,
                                  thickness: 5,
                                  indent: 5,
                                  endIndent: 5,
                                ),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Colors.pink,
                                      size: 20,
                                    ),
                                    Text(
                                      S.of(context).email + " :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Text(
                                      currentUser.value.email ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )),
                              ],
                            ),
                          ),
                        ])),
              ]))
            ]
//                 padding: EdgeInsets.symmetric(vertical: 7),

              // ListTile(
              //   onTap: () {},
              //   dense: true,
              //   title: Text(
              //     S.of(context).full_name,
              //     style: Theme.of(context).textTheme.bodyText2,
              //   ),
              //   trailing: Text(
              //     currentUser.value.name,
              //     style: TextStyle(
              //         color: Theme.of(context).focusColor),
              //   ),
              // ),
              // ListTile(
              //   onTap: () {},
              //   dense: true,
              //   title: Text(
              //     S.of(context).email,
              //     style: Theme.of(context).textTheme.bodyText2,
              //   ),
              //   trailing: Text(
              //     currentUser.value.email,
              //     style: TextStyle(
              //         color: Theme.of(context).focusColor),
              //   ),
              // ),
              // ListTile(
              //   onTap: () {},
              //   dense: true,
              //   title: Text(
              //     S.of(context).phone,
              //     style: Theme.of(context).textTheme.bodyText2,
              //   ),
              //   trailing: Text(
              //     currentUser.value.phone ?? "",
              //     style: TextStyle(
              //         color: Theme.of(context).focusColor),
              //   ),
              // ),
              // ListTile(
              //   onTap: () {},
              //   dense: true,
              //   title: Text(
              //     S.of(context).address,
              //     style: Theme.of(context).textTheme.bodyText2,
              //   ),
              //   trailing: Text(
              //     Helper.limitString(currentUser.value.address ?? S.of(context).unknown),
              //     overflow: TextOverflow.fade,
              //     softWrap: false,
              //     style: TextStyle(color: Theme.of(context).focusColor),
              //   ),
              // ),
              // ListTile(
              //   onTap: () {},
              //   dense: true,
              //   title: Text(
              //     S.of(context).about,
              //     style: Theme.of(context).textTheme.bodyText2,
              //   ),
              //   trailing: Text(
              //     Helper.limitString(currentUser.value.bio),
              //     overflow: TextOverflow.fade,
              //     softWrap: false,
              //     style: TextStyle(color: Theme.of(context).focusColor),
              //   ),
              // ),

              ),
      // Container(
      //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).primaryColor,
      //     borderRadius: BorderRadius.circular(6),
      //     boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      //   ),
      //   child: ListView(
      //     shrinkWrap: true,
      //     primary: false,
      //     children: <Widget>[
      //       ListTile(
      //         leading: Icon(Icons.credit_card),
      //         title: Text(
      //           S.of(context).payments_settings,
      //           style: Theme.of(context).textTheme.bodyText1,
      //         ),
      //         trailing: ButtonTheme(
      //           padding: EdgeInsets.all(0),
      //           minWidth: 50.0,
      //           height: 25.0,
      //           child: PaymentSettingsDialog(
      //             creditCard: _con.creditCard,
      //             onChanged: () {
      //               _con.updateCreditCard(_con.creditCard);
      //               //setState(() {});
      //             },
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         dense: true,
      //         title: Text(
      //           S.of(context).default_credit_card,
      //           style: Theme.of(context).textTheme.bodyText2,
      //         ),
      //         trailing: Text(
      //           _con.creditCard.number.isNotEmpty ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...') : '',
      //           style: TextStyle(color: Theme.of(context).focusColor),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // Container(
      //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).primaryColor,
      //     borderRadius: BorderRadius.circular(6),
      //     boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
      //   ),
      //   child: ListView(
      //     shrinkWrap: true,
      //     primary: false,
      //     children: <Widget>[
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text(
      //           S.of(context).app_settings,
      //           style: Theme.of(context).textTheme.bodyText1,
      //         ),
      //       ),
      //       ListTile(
      //         onTap: () {
      //           Navigator.of(context).pushNamed('/Languages');
      //         },
      //         dense: true,
      //         title: Row(
      //           children: <Widget>[
      //             Icon(
      //               Icons.translate,
      //               size: 22,
      //               color: Theme.of(context).focusColor,
      //             ),
      //             SizedBox(width: 10),
      //             Text(
      //               S.of(context).languages,
      //               style: Theme.of(context).textTheme.bodyText2,
      //             ),
      //           ],
      //         ),
      //         trailing: Text(
      //           S.of(context).english,
      //           style: TextStyle(color: Theme.of(context).focusColor),
      //         ),
      //       ),
      //       // ListTile(
      //       //   onTap: () {
      //       //     Navigator.of(context).pushNamed('/DeliveryAddresses');
      //       //   },
      //       //   dense: true,
      //       //   title: Row(
      //       //     children: <Widget>[
      //       //       Icon(
      //       //         Icons.place,
      //       //         size: 22,
      //       //         color: Theme.of(context).focusColor,
      //       //       ),
      //       //       SizedBox(width: 10),
      //       //       Text(
      //       //         S.of(context).delivery_addresses,
      //       //         style: Theme.of(context).textTheme.bodyText2,
      //       //       ),
      //       //     ],
      //       //   ),
      //       // ),

      //       ListTile(
      //         onTap: () {
      //           Navigator.of(context).pushNamed('/Help');
      //         },
      //         dense: true,
      //         title: Row(
      //           children: <Widget>[
      //             Icon(
      //               Icons.help,
      //               size: 22,
      //               color: Theme.of(context).focusColor,
      //             ),
      //             SizedBox(width: 10),
      //             Text(
      //               S.of(context).help_support,
      //               style: Theme.of(context).textTheme.bodyText2,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
