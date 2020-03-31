import 'package:flutter/material.dart';
import 'package:flutter_app_food/food_list.dart';

class FoodCard extends StatelessWidget{

  final String categoryName;
  final String imagePath;
  final String id;

  FoodCard({this.categoryName, this.imagePath, this.id});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap:  (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return FoodList(categoryName,id);
            }));
      },
      child: Container(
        margin: EdgeInsets.only(right: 20.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Image.network(
                  imagePath,
                  height: 65.0,
                  width: 65.0,
                ),
                SizedBox(width: 20.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(categoryName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Text("$id Kinds",)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}