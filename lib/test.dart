import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPhone extends StatefulWidget {

  @override
  _TestPhoneState createState() => _TestPhoneState();
}

class _TestPhoneState extends State<TestPhone> {
  FirebaseAuth _auth;
  FirebaseUser mCurrentUser;
  String currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      body: Center(
        child: Text(currentUser),
      ),
    );
  }
  _getCurrentUser() async{
    mCurrentUser =await _auth.currentUser();
    //print('Hello ' + mCurrentUser.phoneNumber.toString());
    setState(() {
      mCurrentUser != null ? currentUser = mCurrentUser.phoneNumber.toString() : 'user is null';
    });
  }
}
