import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/common/Common.dart';
import 'package:flutter_app_food/models/commentModel.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/widgets/stepper.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:core';

class DetailsFood extends StatefulWidget {
  FoodModel foodModel;

  DetailsFood(this.foodModel);

  @override
  _DetailsFoodState createState() => _DetailsFoodState();
}

class _DetailsFoodState extends State<DetailsFood> {
  TextEditingController _commentUserController = TextEditingController();
  int selectedRadio;
  FirebaseAuth _auth;
  FirebaseUser _firebaseUser;
  String userId;
  int quantityValue = 1;

  //set Rating user to Firebase
  double updateRating =1.0;

  //get comment from firebase
  List<CommentModel> commentList;

  //get name from firebase using id
  String userName;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
    super.initState();
    selectedRadio = 1;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void dispose() {
    _commentUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              widget.foodModel.name,
              style: TextStyle(color: Colors.black),
            ),
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.foodModel.image),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, position) {
              if (position == 0) {
                return _drawIcon();
              } else if (position == 1) {
                return _drawFoodDetails();
              } else if (position == 2) {
                return _drawDescriptionFood();
              } else if (position == 3) {
                return _drawSizeFood();
              } else if (position == 4) {
                return _showButton();
              } else {
                return Container(
                  height: 30,
                );
              }
            }, childCount: 10),
          ),
        ],
      ),
    );
  }

  Color getRandomColor({int minBrightness = 50}) {
    final random = Random();
    assert(minBrightness >= 0 && minBrightness <= 255);
    return Color.fromARGB(
      0xFF,
      minBrightness + random.nextInt(255 - minBrightness),
      minBrightness + random.nextInt(255 - minBrightness),
      minBrightness + random.nextInt(255 - minBrightness),
    );
  }

  Widget _drawIcon() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 12.0, left: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                _showDialogComment();
              },
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 1, color: Colors.red)),
                child: Icon(
                  Icons.star,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                DocumentReference documentReference =
                    Firestore.instance.collection('Cart').document();
                documentReference.setData({
                  'user_id': userId,
                  'food_id': widget.foodModel.id,
                  'name': widget.foodModel.name,
                  'image': widget.foodModel.image,
                  'price': widget.foodModel.price,
                  'priceTotal': _getPrice(),
                  'discount': widget.foodModel.discount,
                  'quantity': quantityValue.toString(),
                  'documentID': documentReference.documentID
                }).then((value) {});
              },
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 1, color: Colors.red)),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawFoodDetails() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.foodModel.name.toUpperCase(),
              style: TextStyle(fontSize: 22, letterSpacing: 1.2, height: 1.25),
            ),
            SizedBox(height: 10),
            Text('\u0024 ${widget.foodModel.price}',
                style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(120),
              ),
              //  color: Colors.pinkAccent,
              width: 100,
              height: 50,
              child: StepperTouch(
                initialValue: quantityValue,
                direction: Axis.horizontal,
                withSpring: true,
                onChanged: (int value) {
                  if (value <= 0) value = 1;
                  quantityValue = value;
                  print(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawDescriptionFood() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RatingBar(
              ignoreGestures: true,
              itemSize: 40,
              initialRating: double.parse(widget.foodModel.rating),
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
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.foodModel.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawSizeFood() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Size",
              style: TextStyle(color: Colors.black26, fontSize: 20),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setSelectedRadio(value);
                  },
                ),
                Text('Medium'),
                SizedBox(
                  width: 30,
                ),
                Radio(
                  value: 2,
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setSelectedRadio(value);
                  },
                ),
                Text('Large'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _showButton() {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 10,
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.pink,
        padding: const EdgeInsets.all(16.0),
        child: Text('SHOW COMMENT'),
        onPressed: () {
          _commentBottomSheet(context);
        },
      ),
    );
  }



  _getCurrentUser() async {
    _firebaseUser = await _auth.currentUser();
    userId = _firebaseUser.uid;
  }

  String _getPrice() {
    double price =
        ((double.parse(widget.foodModel.price) * quantityValue.toDouble()));
    return price.toString();
  }

  _showDialogComment() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add comment'),
          content: Container(
            child: _showComment(),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              color: Colors.pink,
              child: new Text('Comment'),
              onPressed: () {
                var document =
                    Firestore.instance.collection('Comment').document();
                document.setData({
                  'food_id': widget.foodModel.id,
                  'comment': _commentUserController.text,
                  'rating': updateRating.toString(),
                  'userId': Common.userId,
                  'timeStamp': FieldValue.serverTimestamp()
                }).then((value) {
                  Navigator.of(context).pop();
                  print('update');
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showComment() {
    return Form(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _commentUserController,
              decoration: InputDecoration(hintText: 'Enter Your Comment'),
            ),
            SizedBox(height: 50),
            RatingBar(
              itemSize: 30,
              initialRating: updateRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                updateRating = rating;
                print(rating);
              },
            )
          ],
        ),
      ),
    );
  }

  void _commentBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection('Comment')
                .where('food_id', isEqualTo: widget.foodModel.id)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  var data = snapshot.data.documents;
                  commentList = List<CommentModel>();
                  for (var item in data) {
                    CommentModel comments = CommentModel(
                      item.data['food_id'],
                      item.data['userId'],
                      item.data['comment'],
                      item.data['rating'],
                      item.data['timeStamp'],
                    );
                    commentList.add(comments);
                    //_getUserName(comments);
                  }

                  return ListView(
                    children: commentList.map(_commentUser).toList(),
                  );
              }
            },
          );
        });
  }

  Widget _commentUser(CommentModel commentModel) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      ExactAssetImage("assets/images/placeholder_bg.png"),
                ),
                SizedBox(
                  width: 16,
                ),
                FutureBuilder(
                  future: _getUserName(commentModel),
                  builder: (context,AsyncSnapshot snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(snapshot.data.toString())
                      ],
                    );
                  },
                ),
                SizedBox(width: 50,),
                Text (commentModel.timeStamp.toDate().toIso8601String())
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
                child: Text(commentModel.comment)),
            RatingBar(
              ignoreGestures: true,
              itemSize: 20,
              initialRating: double.parse(commentModel.rating),
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
    );
  }

 Future<String> _getUserName(CommentModel commentModel) async {
   String userName ;
    var document = await Firestore.instance
        .collection('User')
        .document(commentModel.user_id)
        .get();
     userName = document.data['name'];
    return userName;
  }
}
