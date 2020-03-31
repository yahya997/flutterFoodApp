import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/details_food.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/widgets/food_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FoodList extends StatefulWidget {
  String nameCategory, categoryId;

  FoodList(this.nameCategory, this.categoryId);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  List<FoodModel> foodList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            widget.nameCategory,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('Foods').where('category_id',isEqualTo: widget.categoryId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading ...');
              default:
                var data = snapshot.data.documents;
                foodList = List<FoodModel>();
                for (var item in data) {
                  //if (item.data['category_id'] == widget.categoryId) {
                    FoodModel food = FoodModel(
                      item.data['id'],
                      item.data['name'],
                      item.data['image'],
                      item.data['category_id'],
                      item.data['price'],
                      item.data['discount'],
                      item.data['rating'],
                      item.data['description'],
                    );
                    foodList.add(food);
                    print(food.name);
                  //}
                }
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

  Widget _singleFoodList(FoodModel foodList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailsFood(foodList);
          }));
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
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    foodList.image,
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
                        foodList.name,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      RatingBar(
                        ignoreGestures: true,
                        itemSize: 20,
                        initialRating: double.parse(foodList.rating),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
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
