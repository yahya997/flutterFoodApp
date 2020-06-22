import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/const.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/models/popular_model.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_app_food/widgets/bought_foods.dart';
import 'package:flutter_app_food/widgets/food_category.dart';
import 'package:flutter_app_food/widgets/home_top_info.dart';
import 'package:flutter_app_food/widgets/search_field.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _services = Services();

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          FoodCategory(),
          SizedBox(
            height: 20.0,
          ),
          SearchField(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Popular foods",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View all",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          StreamBuilder(
              stream: _services.loadPopularProduct(),
              builder: (context, AsyncSnapshot<List<FoodModel>> snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: new Text(
                      'Error: ${snapshot.error}',
                    ),
                  );
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<FoodModel> popularList = snapshot.data;
                    return Column(
                      children: <Widget>[
                        _buildFoodItems(popularList[0]),
                        _buildFoodItems(popularList[1]),
                        _buildFoodItems(popularList[1]),
                      ],
                    );
                }
              }),
        ],
      ),
    );
  }

  Widget _buildFoodItems(FoodModel popularModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFood(popularModel),
    );
  }
}
