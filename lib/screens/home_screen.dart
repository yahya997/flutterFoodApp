import 'package:flutter/material.dart';
import 'package:flutter_app_food/pages/cart_page.dart';
import 'package:flutter_app_food/pages/home_page.dart';
import 'package:flutter_app_food/pages/order_page.dart';
import 'package:flutter_app_food/pages/profile_page.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;

  HomePage homePage;
  CartPage cartPage;
  OrderPage orderPage;
  ProfilePage profilePage;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();
    homePage = HomePage();
    cartPage = CartPage();
    orderPage = OrderPage();
    profilePage = ProfilePage();
    pages = [homePage, cartPage, orderPage, profilePage];
    currentPage = homePage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
      body: currentPage,
    );
  }
}
