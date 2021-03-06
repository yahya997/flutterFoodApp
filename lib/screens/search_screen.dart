import 'package:flutter/material.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'food_details.dart';

class SearchScreen extends StatefulWidget {
  static String id='SearchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _services = Services();

  @override
  Widget build(BuildContext context) {
    String foodName = ModalRoute
        .of(context)
        .settings
        .arguments;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Search',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StreamBuilder(
          stream: _services.loadFoodsByName(foodName),
          builder: (BuildContext context,
              AsyncSnapshot<List<FoodModel>> snapshot) {
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
                List<FoodModel> foodList = snapshot.data;
                return ListView.builder(
                  // ignore: missing_return
                  itemBuilder: (context, position) {
                    return _singleFoodList(foodList[position]);
                  },
                  itemCount: foodList.length,
                );
            }
          },
        ));
  }

  Widget _singleFoodList(FoodModel foodModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, FoodDetails.id,arguments: foodModel);
        },
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 230.0,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Image.network(
                    foodModel.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: 340.0,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.black12])),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        foodModel.name,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      RatingBar(
                        ignoreGestures: true,
                        itemSize: 20,
                        initialRating: foodModel.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) =>
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}