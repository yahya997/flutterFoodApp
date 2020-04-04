import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/models/popular_model.dart';
import 'package:flutter_app_food/widgets/bought_foods.dart';
import '../widgets/home_top_info.dart';
import '../widgets/food_category.dart';
import '../widgets/search_file.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PopularModel> foodList;
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
                "Popular foods",
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
          StreamBuilder(
             stream: Firestore.instance.collection('Popular').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return new Text('Loading ...');
                default:
                  var data = snapshot.data.documents;
                  foodList = List<PopularModel>();
                  for (var item in data) {
                    PopularModel food = PopularModel(
                        item.data['id'],
                        item.data['name'],
                        item.data['image'],
                        item.data['price'],
                        item.data['discount'],
                        item.data['rating'],
                        item.data['description'],
                      );
                      foodList.add(food);
                  }


              return Column(
                children: foodList.map(_buildFoodItems).toList(),
              );
              }
            }
          ),
        ],
      ),
    );
  }


  Widget _buildFoodItems(PopularModel popularModel){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: BoughtFood(popularModel),
    );
  }

}