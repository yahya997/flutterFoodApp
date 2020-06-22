import 'package:flutter/material.dart';
import 'package:flutter_app_food/models/category_model.dart';
import 'package:flutter_app_food/screens/food_list_screen.dart';

class SingleCategory extends StatelessWidget {

  CategoryModel categoryModel;


  SingleCategory({this.categoryModel});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap:  (){
       Navigator.pushNamed(context, FoodListScreen.id,arguments:categoryModel);
      },
      child: Container(
        margin: EdgeInsets.only(right: 20.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Image.network(
                  categoryModel.image,
                  height: 65.0,
                  width: 65.0,
                ),
                SizedBox(width: 20.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(categoryModel.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    Text(" Kinds",)
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
