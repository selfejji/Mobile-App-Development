import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:FriendlyChat/lib/user.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong querying users");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            User user =
                User.fromJson(doc.id, doc.data() as Map<String, dynamic>);
            return ListTile(
              title: Text(user.email),
              subtitle: Text(user.role),
            );
          }).toList());
        },
      ),
    );
  }
}
