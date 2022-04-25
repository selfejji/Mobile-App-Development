import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:artist_manager/add_user_dialog.dart';
import 'package:artist_manager/database/model/user.dart';
import 'package:artist_manager/database/database_helper.dart';
import 'package:artist_manager/home_presenter.dart';
import 'package:artist_manager/list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Item {
  const Item(this.name,this.icon,this.method);
  final String name;
  final Icon icon;
  final Future<List<User>> method;
}

class _MyHomePageState extends State<MyHomePage> implements HomeContract {
  late HomePresenter homePresenter;
 
  @override
  void initState() {
    super.initState();
    homePresenter = HomePresenter(this);
  }

  displayRecord() {
    setState(() {});
  }

   // ignore: avoid_init_to_null
  Item? selectedOption = null;
  
  List<Item> option = <Item>[
    Item('Get User Range',const Icon(Icons.flag,color:  Color(0xFF167F67),), DatabaseHelper.internal().getUserRange(2, 3)),
    Item('Find Null User',const Icon(Icons.flag,color:  Color(0xFF167F67),), DatabaseHelper.internal().findNUllUser()),
    Item('Get Top 5 Users',const Icon(Icons.flag,color:  Color(0xFF167F67),), DatabaseHelper.internal().getTopFive()),
    Item('Find Specific User',const Icon(Icons.flag,color:  Color(0xFF167F67),), DatabaseHelper.internal().getSpecificUser("Sam")),
    Item('Check Specific User',const Icon(Icons.flag,color:  Color(0xFF167F67),), DatabaseHelper.internal().checkSpecificUser("Sam")),
    Item('Delete User Range',const Icon(Icons.flag,color:  Color(0xFF167F67),),  DatabaseHelper.internal().getUserRange(2, 3)),
  ];


  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.center;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text('User Database',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            DropdownButton<Item>(
            hint:  const Text("Select item"),
            value: selectedOption,
            // ignore: non_constant_identifier_names
            onChanged: (Item? Value) {
              setState(() {
                selectedOption = Value!;
              });
            },
            items: option.map((Item option) {
              return  DropdownMenuItem<Item>(
                value: option,
                child: Row(
                  children: <Widget>[
                    option.icon,
                    const SizedBox(width: 10,),
                    Text(
                      option.name,
                      style:  const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          ],
        ),
      ),
    );
  }

  Future _openAddUserDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AddUserDialog().buildAboutDialog(context, this, false, null),
    );

    setState(() {});
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
        onPressed: _openAddUserDialog,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body: FutureBuilder<List<User>>(
        future: homePresenter.getUser(),
        builder: (context, snapshot) {
          // ignore: avoid_print
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
              ? UserList(data!,homePresenter)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
