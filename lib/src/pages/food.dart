import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/food_controller.dart';
import '../controllers/cart_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CircularLoadingWidget.dart';
import '../widget/AppBarWebili.dart';
import '../elements/DrawerWidget.dart';
import '../models/route_argument.dart';
import '../models/restaurant.dart';
import '../models/extra.dart';
import '../repository/user_repository.dart';
import 'package:scoped_model/scoped_model.dart';
import '../store/refresh_model.dart';
import '../helpers/vdialog.dart';

// ignore: must_be_immutable
class FoodWidget extends StatefulWidget {
  RouteArgument routeArgument;
  final String heroTag;
  final Restaurant restaurant;
  FoodWidget({Key key, this.routeArgument, this.restaurant, this.heroTag})
      : super(key: key);

  @override
  _FoodWidgetState createState() {
    return _FoodWidgetState();
  }
}

class _FoodWidgetState extends StateMVC<FoodWidget>
    with TickerProviderStateMixin {
  FoodController _con;
  CartController _con2;
  bool disabled = false;
  bool addedToCart = false;
  Vdialog vdialog = new Vdialog();
  Extra selectedExtra;
  List selectedExtras;
  _FoodWidgetState() : super(FoodController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con2 = new CartController();
    _con2.listenForCarts();
    _con.listenForFood(foodId: widget.routeArgument.id);
    _con.listenForCart();
    _con.listenForFavorite(foodId: widget.routeArgument.id);
    super.initState();

    setState(() {
      selectedExtras = new List<Extra>();
      //selectedExtra = _con.food.extras.first;      //where((extra) => extra.extraGroupId == extraGroup.id)
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // setSelectedExtra(currentExtra) {
  //   _con.food.extras.forEach((element) {
  //     if (element.extraGroupId == currentExtra.extraGroupId) {
  //       if (element.id == currentExtra.id) {
  //         element.checked = true;
  //       } else {
  //         element.checked = false;
  //       }
  //     }
  //     print(element.toMap());
  //   });

  //   selectedExtras.clear();

  //   _con.food.extras.forEach((element) {
  //     if (element.checked) {
  //       setState(() {
  //         selectedExtras.add(element);
  //       });
  //     }
  //   });

  //   var result = selectedExtras.firstWhere(
  //           (element) => (element.extraGroupId == currentExtra.extraGroupId),
  //           orElse: () => null) ??
  //       currentExtra;
  //   print(result.name);
  // }
  setSelectedExtra(extra, value) {
    _con.food.extras.forEach((element) {
      if (element.extraGroupId == extra.extraGroupId) {
        extra.checked = value;
      }
      print(element.toMap());
    });

    selectedExtras.clear();

    _con.food.extras.forEach((element) {
      if (element.checked) {
        setState(() {
          selectedExtras.add(element);
        });
      }
    });

    var result = selectedExtras.firstWhere(
            (element) => (element.extraGroupId == extra.extraGroupId),
            orElse: () => null) ??
        extra;
    print(result.name);
  }

  List<Widget> createRadioListExtras(extras, extraGroupId) {
    if (selectedExtras == null || selectedExtras.length == 0) {
      selectedExtras.add(extras.first);
      _con.food.extras
          .firstWhere((element) => element.extraGroupId == extraGroupId)
          .checked = true;
    } else {
      var extraGroupIdExist = selectedExtras.firstWhere(
          (e) => e.extraGroupId == extraGroupId,
          orElse: () => null);
      if (extraGroupIdExist == null) {
        selectedExtras.add(extras.first);
        _con.food.extras
            .firstWhere((element) => element.extraGroupId == extraGroupId)
            .checked = true;
      }
      print(selectedExtras.toList().toString());
    }

    List<Widget> widgets = [];

    for (Extra extra in extras) {
      var result = selectedExtras.firstWhere(
              (element) => (element.extraGroupId == extra.extraGroupId),
              orElse: () => null) ??
          extra;

      widgets.add(
        ListTile(
          title: Row(children: [
            Text(extra.name),
            extra.price != 0
                ? Text(" +" + extra.price.toString() + "0Mad",
                    style: TextStyle(color: Theme.of(context).accentColor))
                : SizedBox(height: 0)
          ]),
          leading: Checkbox(
            value: extra.checked,
            // groupValue: _character,
            onChanged: (value) {
              setSelectedExtra(extra, value);
            },
          ),
        ),
        // RadioListTile(
        //     value: extra,
        //     groupValue: selectedExtras.firstWhere(
        //             (element) => (element.extraGroupId == extra.extraGroupId),
        //             orElse: () => null) ??
        //         extra,
        //     title: Row(children: [
        //       Text(extra.name),
        //       extra.price != 0
        //           ? Text(" +" + extra.price.toString() + "0Mad",
        //               style: TextStyle(color: Theme.of(context).accentColor))
        //           : SizedBox(height: 0)
        //     ]),
        //     onChanged: (currentExtra) {
        //       setSelectedExtra(currentExtra);
        //     },
        //     // selected: extra.checked
        //     ),
      );
    }

    return widgets;
  }

  String choose_sentence(min, max) {
    if (min != null && max != null && max > min)
      return "Choisissez entre ${min} et ${max} éléments:";

    if (max != null && max > 0) return "Choisissez ${max} éléments maximum:";

    if (min != null && min > 0) return "Choisissez ${min} éléments minimum:";

    return "Choisissez 1 seul élément:";
  }

  @override
  Widget build(BuildContext context) {
    return _con.food == null
        ? CircularLoadingWidget(height: 500)
        : ScopedModelDescendant<RefreshModel>(builder: (context, child, model) {
            //this.selectedExtras.clear();
            return Scaffold(
              key: _con.scaffoldKey,
              drawer: DrawerWidget(),
              appBar: AppBarWebili(parentScaffoldKey: _con.scaffoldKey),
              body: _con.food == null || _con.food?.image == null
                  ? CircularLoadingWidget(height: 500)
                  : RefreshIndicator(
                      onRefresh: _con.refreshFood,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 100),
                            padding: EdgeInsets.only(bottom: 15),
                            child: CustomScrollView(
                              primary: true,
                              shrinkWrap: false,
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: Wrap(
                                      runSpacing: 8,
                                      children: [
                                        _con.food.extraGroups == null
                                            ? CircularLoadingWidget(height: 100)
                                            : ListView.separated(
                                                padding: EdgeInsets.all(0),
                                                itemBuilder:
                                                    (context, extraGroupIndex) {
                                                  var extraGroup = _con
                                                      .food.extraGroups
                                                      .elementAt(
                                                          extraGroupIndex);
                                                  String choose_sentence = this
                                                      .choose_sentence(
                                                          extraGroup.min_select,
                                                          extraGroup
                                                              .max_select);
                                                  return Column(
                                                    children: <Widget>[
                                                      ListTile(
                                                          dense: true,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0),
                                                          title: Column(
                                                            children: [
                                                              Text(
                                                                extraGroup.name,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1,
                                                              ),
                                                              Divider(
                                                                color: Color(
                                                                    0xFFECEFF1),
                                                                height: 2,
                                                                thickness: 2,
                                                                indent: 20,
                                                                endIndent: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    choose_sentence,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .caption,
                                                                  ),
                                                                  Text(
                                                                    "Obligatoire*",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontSize:
                                                                            8),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                      Column(
                                                        children: createRadioListExtras(
                                                            _con.food.extras
                                                                .where((extra) =>
                                                                    extra
                                                                        .extraGroupId ==
                                                                    extraGroup
                                                                        .id),
                                                            extraGroup.id),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return SizedBox(height: 10);
                                                },
                                                itemCount: _con
                                                    .food.extraGroups.length,
                                                primary: false,
                                                shrinkWrap: true,
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.15),
                                        offset: Offset(0, -2),
                                        blurRadius: 5.0)
                                  ]),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: Row(
                                  children: <Widget>[
                                    Stack(
                                      fit: StackFit.loose,
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: <Widget>[
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                40,
                                            child: FlatButton(
                                              onPressed: () {
                                                if (disabled) {
                                                  Timer(Duration(seconds: 2),
                                                      () {
                                                    setState(() {
                                                      disabled = false;
                                                    });
                                                  });
                                                } else if (verifyLimitExtras()) {
                                                  setState(() {
                                                    disabled = true;
                                                  });
                                                  if (currentUser
                                                          .value.apiToken ==
                                                      null) {
                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            "/Login");
                                                  } else {
                                                    verifyIfSameRestaurant(
                                                        model);
                                                  }
                                                }
                                              },
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              color:
                                                  Theme.of(context).accentColor,
                                              shape: StadiumBorder(),
                                              child: Container(
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  // S.of(context).add_to_cart,
                                                  // textAlign: TextAlign.start,
                                                  "Terminer",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          });
  }

  verifyLimitExtras() {
    var condition_satisfied = true;
    var checked_count = 0;

    for (final group in _con.food.extraGroups) {
      condition_satisfied = true;
      checked_count = 0;

      for (final extra in _con.food.extras) {
        if (extra.extraGroupId == group.id) {
          if (extra.checked) {
            checked_count++;
          }
        }
      }
      if (checked_count > (group.max_select ?? 1) ||
          checked_count < (group.min_select ?? 1)) {
        condition_satisfied = false;
        break;
      }
    }
    if (condition_satisfied == false)
      vdialog.pop(
          context, "Veuillez respecter le nombre de suppléments à choisir");

    return condition_satisfied;
  }

  verifyIfSameRestaurant(model) {
    if (_con.isSameRestaurants(_con.food)) {
      addedToCart = true;
      _con.addToCart(_con.food).whenComplete(() => new Future.delayed(
          const Duration(milliseconds: 1000), () => Navigator.pop(context)));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AddToCartAlertDialogWidget(
            oldFood: _con.carts.elementAt(0)?.food,
            newFood: _con.food,
            onPressed: (food, {reset: true}) {
              // to refresh the card
              model.refresh();
              return _con
                  .addToCart(_con.food, reset: true)
                  .whenComplete(() => Navigator.pop(context));
            },
          );
        },
      );
    }
  }
}
