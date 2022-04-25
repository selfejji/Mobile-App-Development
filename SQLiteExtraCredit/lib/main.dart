import 'package:flutter/material.dart';
import 'package:artist_manager/homescreen.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Database',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:  const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFAD32)),
      ),
      home: const MyHomePage(title: 'Flutter Database'),
    );
  }
}