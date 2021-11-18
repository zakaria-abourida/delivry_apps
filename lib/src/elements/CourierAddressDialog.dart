import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart';
import '../models/contact.dart';

// ignore: must_be_immutable
class CourierAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _courierAddressFormKey = new GlobalKey<FormState>();
  Contact contact = new Contact();

  CourierAddressDialog({this.context, this.address, this.onChanged}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  S.of(context).delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _courierAddressFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).hint_full_address,
                            labelText: S.of(context).description + "*"),
                        initialValue: address.description?.isNotEmpty ?? false
                            ? address.description
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Description invalide'
                            : null,
                        onSaved: (input) => address.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).full_name,
                            labelText: S.of(context).full_name),
                        initialValue: address.contact?.name?.isNotEmpty ?? false
                            ? address.contact.name
                            : null,
                        /*  validator: (input) =>
                            input.trim().length == 0 ? 'Nom invalide' : null, */
                        onSaved: (input) => contact.name = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.phone,
                        decoration: getInputDecoration(
                            hintText: S.of(context).phone,
                            labelText: S.of(context).phone),
                        initialValue:
                            address.contact?.phone?.isNotEmpty ?? false
                                ? address.contact.phone
                                : null,
                        /*  validator: (input) => input.trim().length < 10
                            ? S.of(context).not_a_valid_phone
                            : null, */
                        onSaved: (input) => contact.phone = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).hint_full_address,
                            labelText: S.of(context).full_address + "*"),
                        initialValue: address.address?.isNotEmpty ?? false
                            ? address.address
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? S.of(context).notValidAddress
                            : null,
                        onSaved: (input) => address.address = input,
                      ),
                    ),

                    /*   SizedBox(
                      width: double.infinity,
                      child: CheckboxFormField(
                        context: context,
                        initialValue: address.isDefault ?? false,
                        onSaved: (input) => address.isDefault = input,
                        title: Text("Est moi"),
                      ),
                    ) */
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "(*) Obligatoire",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_courierAddressFormKey.currentState.validate()) {
      _courierAddressFormKey.currentState.save();
      address.contact = contact;
      onChanged(address);
      Navigator.pop(context);
    }
  }
}
