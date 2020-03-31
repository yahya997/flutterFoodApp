import 'package:flutter/material.dart';
import 'package:flutter_app_food/widgets/bought_foods.dart';
import 'package:flutter_app_food/widgets/food_category.dart';
import 'package:flutter_app_food/widgets/home_top_info.dart';
import 'package:flutter_app_food/widgets/search_file.dart';

import 'models/food_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<Food> _foods = foods;
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          FoodCategory(),
          SizedBox(height: 20.0,),
          SearchField(),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Frequently Bought Foods",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: Text(
                  "View all",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
           // children: _foods.map(_buildFoodItems).toList(),
          ),
        ],
      ),
    );
  }

/*  Widget _buildFoodItems(Food food){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFood(
        id: food.id,
        name: food.name,
        imagePath: food.image,
        category: food.category_id,
        discount: food.discount,
        price: food.price,
        ratings: food.rating,
      ),
    );
  }*/

}