import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/common/Common.dart';
import 'package:flutter_app_food/screens/main_screen.dart';
import 'package:flutter_app_food/test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'otp_input.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;

  OTPScreen({
    Key key,
    @required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _nameUserController = TextEditingController();
  TextEditingController _addressUserController = TextEditingController();
  TextEditingController _phoneUserController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  ProgressDialog pr;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black, hintText: '333333');

  bool isCodeSent = false;
  String _verificationId;

  @override
  void dispose() {
    _nameUserController.dispose();
    _addressUserController.dispose();
    _phoneUserController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    progress();
    print("isValid - $isCodeSent");
    print("mobiel ${widget.mobileNumber}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0, bottom: 16, top: 4),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Verify Details",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "OTP sent to ${widget.mobileNumber}",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinInputTextField(
                pinLength: 6,
                decoration: _pinDecoration,
                controller: _pinEditingController,
                autoFocus: true,
                textInputAction: TextInputAction.done,
                onSubmit: (pin) {
                  if (pin.length == 6) {
                    _onFormSubmitted();
                  } else {
                    showToast("Invalid OTP", Colors.red);
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Text(
                      "ENTER OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_pinEditingController.text.length == 6) {
                        _onFormSubmitted();
                      } else {
                        showToast("Invalid OTP", Colors.red);
                      }
                    },
                    padding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          // Handle loogged in state
          print("type" + value.user.phoneNumber);
          print(value.user.runtimeType);
          _displayDialog(value.user);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        // Handle loogged in state
        print(value.user.runtimeType);
        print(value.user.phoneNumber);
        _displayDialog(value.user);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }

  _displayDialog(FirebaseUser user) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Register'),
          content: showRegisterInfo(user),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              color: Colors.pink,
              child: new Text('REGISTER'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  pr.show();
                  Firestore.instance.collection('User').document(user.uid).setData({
                    'name': _nameUserController.text,
                    'phone': user.phoneNumber.toString(),
                    'address': _addressUserController.text
                  }).then((onValue) {
                    pr.dismiss();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                            (Route<dynamic> route) => false);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget showRegisterInfo(FirebaseUser user) {
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.width/2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameUserController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'your name is required';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Your Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _addressUserController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your address is required';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Your address'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneUserController..text=user.phoneNumber,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Phone Number is required';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Phone Number'),
            ),
          ],
        ),
      ),
    );
  }

  progress() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Loading ...',
      borderRadius: 8.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
    );
  }
}


