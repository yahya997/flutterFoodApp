import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_firebase/otp_screen.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 13) {
      updateState(() {
        isValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context ) {
    return Scaffold(
      body: StatefulBuilder(builder:
          (BuildContext context, StateSetter state) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.7,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40,),
              Text(
                'LOGIN',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneNumberController,
                  autofocus: true,
                  onChanged: (text) {
                    validate(state);
                  },
                  decoration: InputDecoration(
                    labelText: "10 digit mobile number",
                    prefix: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  autovalidate: true,
                  autocorrect: false,
                  maxLengthEnforced: true,
                  validator: (value) {
                    return !isValid
                        ? 'Please provide a valid 10 digit phone number'
                        : null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width:
                    MediaQuery.of(context).size.width *
                        0.85,
                    child: RaisedButton(
                      color: !isValid
                          ? Theme.of(context)
                          .primaryColor
                          .withOpacity(0.5)
                          : Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(0.0)),
                      child: Text(
                        !isValid
                            ? "ENTER PHONE NUMBER"
                            : "CONTINUE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (isValid) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OTPScreen(
                                      mobileNumber:
                                      _phoneNumberController
                                          .text,
                                    ),
                              ));
                        } else {
                          validate(state);
                        }
                      },
                      padding: EdgeInsets.all(16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
