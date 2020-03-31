
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/common/Common.dart';
import 'package:flutter_app_food/screens/main_screen.dart';
import 'package:flutter_app_food/sign_in.dart';
import 'package:flutter_app_food/test.dart';
import 'package:scoped_model/scoped_model.dart';
import 'HomeScreen.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

