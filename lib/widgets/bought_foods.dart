import 'package:flutter/material.dart';

import 'package:flutter_app_food/models/popular_model.dart';
import 'package:flutter_app_food/popular_detalis_food.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BoughtFood extends StatefulWidget {

  PopularModel popularModel;


  BoughtFood(this.popularModel);

  @override
  _BoughtFoodState createState() => _BoughtFoodState();
}

class _BoughtFoodState extends State<BoughtFood> {
  var cardText = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PopularDetailsFood(widget.popularModel);
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 230.0,
              width: 340.0,
              child: Image.network(
                  widget.popularModel.image,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.popularModel.name,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      RatingBar(
                        ignoreGestures: true,
                        itemSize: 20,
                        initialRating: double.parse(widget.popularModel.rating),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        widget.popularModel.price.toString(),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent),
                      ),
                      Text("Min order",
                          style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
