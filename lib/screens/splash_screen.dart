import 'package:flutter/material.dart';
import 'package:flutter_app_food/screens/home_screen.dart';
import 'package:flutter_app_food/screens/login_screen.dart';
import 'package:flutter_app_food/stores/login_store.dart';
import 'package:provider/provider.dart';
import '../const.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'SplashScreen';

  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.id, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
    );
  }
}
