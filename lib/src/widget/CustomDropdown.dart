import 'package:flutter/material.dart';

import '../controllers/delivery_addresses_controller.dart';
import '../models/address.dart';
import '../pages/delivery_addresses.dart';
import '../repository/settings_repository.dart' as settingRepo;

class CustomDropdown extends StatefulWidget {
  final List<Address> addresses;
  final VoidCallback refreshAddresses;
  const CustomDropdown(
      {Key key, @required this.addresses, this.refreshAddresses})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;
  Address address = null;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(settingRepo.deliveryAddress.value.address);

    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    // print(height);
    // print(width);
    // print(xPosition);
    // print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    var count =
        widget.addresses.length > 0 ? widget.addresses.length + 2.0 : 2.0;
    // print(count*height);
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        height: (count * height) + (12 * count),
        child: DropDown(
            itemHeight: (count * height) + (12 * count),
            addresses: widget.addresses,
            removeFloatingDropDown: () {
              floatingDropdown.remove();
              isDropdownOpened = !isDropdownOpened;
            },
            refreshAddresses: widget.refreshAddresses),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var count = 0;
    return ValueListenableBuilder(
        valueListenable: settingRepo.deliveryAddress,
        builder: (context, Address _address, _) {
          count++;
          print("ValueListenableBuilder ${count} :" +
              _address?.toMap().toString());
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            key: actionKey,
            onTap: () {
              setState(() {
                if (isDropdownOpened) {
                  floatingDropdown.remove();
                } else {
                  findDropdownData();
                  floatingDropdown = _createFloatingDropdown();
                  Overlay.of(context).insert(floatingDropdown);
                }
                isDropdownOpened = !isDropdownOpened;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 110,
                    child: Text(
                      settingRepo.deliveryAddress?.value?.description == null
                          ? "Localisation actuelle"
                          : settingRepo.deliveryAddress?.value?.description ==
                                  "Localisation actuelle"
                              ? "Localisation actuelle"
                              : _address?.address,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class DropDown extends StatefulWidget {
  final double itemHeight;
  final List<Address> addresses;
  final VoidCallback removeFloatingDropDown;
  final VoidCallback refreshAddresses;
  const DropDown(
      {Key key,
      this.itemHeight,
      this.addresses,
      this.removeFloatingDropDown,
      this.refreshAddresses})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  //changeDeliveryAddressToCurrentLocation
  //changeDeliveryAddress(address)

  List<Address> addressesList;
  DeliveryAddressesController _con = new DeliveryAddressesController();
  int selectedItem = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Material(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropDownItem.first(
                text: 'Localisation actuelle',
                image: Image(
                  image: AssetImage('assets/img/adresse.png'),
                  width: 14,
                  height: 16,
                ),
                isSelected: settingRepo.deliveryAddress.value.description ==
                    "Localisation actuelle",
                onPress: () {
                  _con
                      .changeDeliveryAddressToCurrentLocation()
                      .whenComplete(() => widget.removeFloatingDropDown());
                }),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 0,
              indent: 5,
              endIndent: 5,
            ),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.addresses.length > 5
                    ? widget.addresses.getRange(0, 5).length
                    : widget.addresses.length,
                itemBuilder: (context, index) {
                  print(settingRepo.deliveryAddress.value.id);
                  return DropDownItem(
                      text: widget.addresses.elementAt(index).address ?? '',
                      description:
                          widget.addresses.elementAt(index).description,
                      iconData: Icons.pin_drop,
                      isSelected: settingRepo.deliveryAddress.value.id == null
                          ? false
                          : widget.addresses.elementAt(index).id ==
                              settingRepo.deliveryAddress.value.id,
                      onPress: () {
                        widget.addresses.elementAt(index).isDefault = true;
                        _con
                            .changeDeliveryAddress(
                                widget.addresses.elementAt(index))
                            .whenComplete(
                                () => widget.removeFloatingDropDown());
                      });
                }),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 0,
              indent: 5,
              endIndent: 5,
            ),
            Expanded(
              child: DropDownItem.last(
                text: "Ajouter une adresse",
                iconData: Icons.add_circle_rounded,
                onPress: () {
                  widget.removeFloatingDropDown();
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryAddressesWidget()))
                      .whenComplete(() {
                    widget.refreshAddresses();
                    settingRepo.deliveryAddress.value = widget.addresses
                        .firstWhere((element) => element.isDefault);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String text;
  final String description;
  final IconData iconData;
  final Image image;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;
  final VoidCallback onPress;

  const DropDownItem(
      {Key key,
      this.text,
      this.description,
      this.iconData,
      this.image,
      this.isSelected = false,
      this.isFirstItem = false,
      this.isLastItem = false,
      this.onPress})
      : super(key: key);

  factory DropDownItem.first(
      {String text,
      IconData iconData,
      Image image,
      bool isSelected,
      VoidCallback onPress}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      image: image,
      isSelected: isSelected,
      isFirstItem: true,
      onPress: onPress,
    );
  }

  factory DropDownItem.last(
      {String text, IconData iconData, VoidCallback onPress}) {
    return DropDownItem(
      text: text,
      iconData: iconData,
      isLastItem: true,
      onPress: onPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image != null
                  ? image
                  : Image(
                      width: 10,
                      height: 16,
                      image: AssetImage("assets/img/pin.png"),
                      fit: BoxFit.fill),
              Padding(
                padding: EdgeInsets.only(left: 5.0, top: 5, bottom: 5),
                child: description != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 110,
                              child: Text(
                                text,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade900, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width - 110,
                                child: Text(
                                  description,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 10),
                                ))
                          ])
                    : Text(
                        text,
                        style: TextStyle(
                            color: Colors.grey.shade900, fontSize: 12),
                      ),
              ),
              isLastItem == false ? Spacer() : Text(""),
              isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Theme.of(context).accentColor,
                    )
                  : Text('')
            ],
          ),
        ));
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ArrowShape extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getOuterPath
    return getClip(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }

  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }
}
