// ignore_for_file: unnecessary_new

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:artist_manager/database/database_helper.dart';
import 'package:artist_manager/database/model/user.dart';

class AddUserDialog {
  final teFirstName = TextEditingController();
  final teLastFirstName = TextEditingController();
  final teDOB = TextEditingController();
  late User user;

  static const TextStyle linkStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(
      BuildContext context, _myHomePageState, bool isEdit, User? user) {
    // ignore: unnecessary_null_comparison
    if (user != null) {
      this.user=user;
      teFirstName.text = user.firstName;
      teLastFirstName.text = user.lastName;
      teDOB.text = user.dob;
    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Edit' : 'Add new User'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Enter first name", teFirstName),
            getTextField("Enter last name", teLastFirstName),
            getTextField("DD-MM-YYYY", teDOB),
            new GestureDetector(
              onTap: () {
                addRecord(isEdit);
                _myHomePageState.displayRecord();
                Navigator.of(context).pop();
              },
              child: new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(
                    isEdit?"Edit":"Add", const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: const EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: const TextStyle(
          color: Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Future addRecord(bool isEdit) async {
    var db = new DatabaseHelper();
    var user = new User(teFirstName.text, teLastFirstName.text, teDOB.text);
    if (isEdit) {
      user.setUserId(this.user.id);
      await db.update(user);
    } else {
      await db.saveUser(user);
    }
  }
}