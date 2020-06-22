import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_food/screens/home_screen.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_app_food/stores/login_store.dart';
import 'package:flutter_app_food/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class InfoScreen extends StatefulWidget {
  static String id = 'InfoScreen';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _name, _address,_phone;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return new Container(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image.asset(
              'assets/bg_img.jpg',
              fit: BoxFit.fitHeight,
            ),
            new Scaffold(
              backgroundColor: Colors.transparent,
              body: Form(
                key: _globalKey,
                child: new Center(
                  child: new Center(
                    child: new BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 6.0,
                        sigmaY: 6.0,
                      ),
                      child: new Container(
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB4C56C).withOpacity(0.01),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        child: new Container(
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                height: height * .2,
                              ),
                              CustomTextField(
                                onClick: (value) {
                                  _name = value;
                                },
                                icon: Icons.perm_identity,
                                hint: 'Enter your name',
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              CustomTextField(
                                onClick: (value) {
                                  _address = value;
                                },
                                icon: Icons.location_city,
                                hint: 'Enter your address',
                              ),
                              SizedBox(
                                height: height * .02,
                              ),
                              CustomTextField(
                                onClick: (value) {
                                  _phone =value;
                                },
                                value: loginStore.firebaseUser.phoneNumber,
                                icon: Icons.phone,
                                hint: 'Enter your phone',
                              ),
                              SizedBox(
                                height: height * .2,
                              ),
                              Container(

                                margin:  EdgeInsets.symmetric(
                                    horizontal: width*.09, vertical: 10),
                                child: Builder(
                                  builder: (context) => RaisedButton(
                                    onPressed: () {
                                      if (_globalKey.currentState.validate()) {
                                        _globalKey.currentState.save();
                                        try {
                                          Services _services = Services();
                                          _services.storeUsers(
                                              loginStore.firebaseUser.uid,
                                            {kName: _name,
                                            kAddress: _address,
                                            kPhone: _phone
                                          });
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text('Successfully'),
                                          ));
                                          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
                                        }  catch (ex) {
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(ex.message),
                                          ));
                                        }
                                      }
                                    },
                                    color: primaryColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14))),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Register',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              color: primaryColorLight,
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
