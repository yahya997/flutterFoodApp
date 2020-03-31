import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/common/Common.dart';
import 'package:flutter_app_food/pages/cart_page.dart';
import 'package:flutter_app_food/pages/order_page.dart';
import 'package:flutter_app_food/pages/profile_page.dart';
import 'package:flutter_app_food/sign_in.dart';
import '../pages/home_page.dart';


class MainScreen extends StatefulWidget {


  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  FirebaseAuth _auth;
  FirebaseUser mCurrentUser;
  String currentUser;



  int currentTabIndex = 0;

  HomePage homePage;
  CartPage orderPage;
  OrderPage favoritePage;
  ProfilePage profilePage;

  List<Widget> pages;
  Widget currentPage;
  @override
  void initState() {
    super.initState();
    homePage=HomePage();
    orderPage = CartPage();
    favoritePage = OrderPage();
    profilePage = ProfilePage();
    pages = [homePage,orderPage,favoritePage,profilePage];
    currentPage=homePage;

    //getUser
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          setState(() {
            currentTabIndex=index;
            currentPage = pages[index];
          });
        },
        currentIndex:  currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorite'),
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
  _getCurrentUser() async{
    mCurrentUser =await _auth.currentUser();
    setState(() {
      mCurrentUser != null ? Common.userId = mCurrentUser.uid : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()),(Route<dynamic> route) => false);
    });
  }
}
