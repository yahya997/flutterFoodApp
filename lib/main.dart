import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/const.dart';
import 'package:flutter_app_food/provider/cart_item.dart';
import 'package:flutter_app_food/screens/food_details.dart';
import 'package:flutter_app_food/screens/food_list_screen.dart';
import 'package:flutter_app_food/screens/home_screen.dart';
import 'package:flutter_app_food/screens/info_screen.dart';
import 'package:flutter_app_food/screens/login_screen.dart';
import 'package:flutter_app_food/screens/search_screen.dart';
import 'package:flutter_app_food/screens/splash_screen.dart';
import 'package:flutter_app_food/stores/login_store.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(builder: (context) => MyApp(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
        ChangeNotifierProvider<CartItem>(
          create: (context) => CartItem(),
        ),
      ],
      child: MaterialApp(

        theme: ThemeData(primaryColor: primaryColor,primaryColorLight: primaryColorLight),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          SplashScreen.id: (context) => SplashScreen(),
          InfoScreen.id: (context) => InfoScreen(),
          FoodListScreen.id: (context) => FoodListScreen(),
          FoodDetails.id: (context) => FoodDetails(),
          SearchScreen.id: (context) => SearchScreen(),
        },
      ),
    );
  }
}