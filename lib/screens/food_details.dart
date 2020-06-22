import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/const.dart';
import 'package:flutter_app_food/models/comment_model.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/provider/cart_item.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_app_food/widgets/sliver_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FoodDetails extends StatefulWidget {
  static String id = 'FoodDetails';

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final Firestore _firestore = Firestore.instance;
  final _services = Services();
  FirebaseAuth _auth;
  FirebaseUser _firebaseUser;
  String userId;
  TextEditingController _commentUserController = TextEditingController();
  int selectedRadio;
  double imageSize = 266.0;
  int _quantity = 1;

  //set Rating user to Firebase
  double updateRating = 1.0;

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    FoodModel foodModel = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Builder(
        builder: (context) => new SliverContainer(
          floatingActionButton: Container(
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _showDialogComment(foodModel);
                  },
                  child: new Container(
                    margin: EdgeInsets.only(left: 30),
                    height: 60.0,
                    width: 60.0,
                    child: Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: primaryColorLight, width: 2.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    addToCart(context, foodModel);
                  },
                  child: new Container(
                    height: 60.0,
                    width: 60.0,
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black,
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: primaryColorLight, width: 2.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          expandedHeight: 256.0,
          slivers: <Widget>[
            new SliverAppBar(
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: false,
              elevation: 10,
              expandedHeight: imageSize,
              pinned: true,
              flexibleSpace: new FlexibleSpaceBar(
                title: Text(foodModel.name),
                background: new Image.network(
                  foodModel.image == null ? '' : foodModel.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate([
                _drawFoodDetails(foodModel),
                _drawDescriptionFood(foodModel),
                //_drawSizeFood(),
                _showButton(foodModel),
                Container(
                  height: height - imageSize,
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawFoodDetails(FoodModel foodModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                foodModel.name.toUpperCase(),
                style:
                    TextStyle(fontSize: 22, letterSpacing: 1.2, height: 1.25),
              ),
              SizedBox(height: 10),
              Text('\u0024 ${foodModel.price}', style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: primaryColor,
                      child: GestureDetector(
                        onTap: () {
                          subtract();
                        },
                        child: SizedBox(
                          child: Icon(Icons.remove),
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    _quantity.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                  ClipOval(
                    child: Material(
                      color: primaryColor,
                      child: GestureDetector(
                        onTap: () {
                          add();
                        },
                        child: SizedBox(
                          child: Icon(Icons.add),
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        print(_quantity);
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
      print(_quantity);
    });
  }

  Widget _drawDescriptionFood(FoodModel foodModel) {
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
              initialRating: checkDouble(foodModel.rating) / foodModel.ratingCount,
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
                foodModel.description,
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

  Widget _showButton(foodModel) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .07,
        child: Builder(
          builder: (context) => RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            color: primaryColor,
            onPressed: () {
              _commentBottomSheet(context, foodModel);
            },
            child: Text(
              'show comment'.toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  _showDialogComment(FoodModel foodModel) {
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
              textColor: Colors.redAccent,
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              color: primaryColor,
              textColor: Colors.white,
              child: new Text('Comment'),
              onPressed: () {

                Map<String, dynamic> data = {
                  'food_id': foodModel.id,
                  'comment': _commentUserController.text,
                  'rating': updateRating.toString(),
                  'userId': userId,
                  'timeStamp': FieldValue.serverTimestamp()
                };
                var documentRef = _firestore.collection(kComment).document();
                documentRef.setData(data).then((value) {
                  print(foodModel.id);
                  print('yahyahaya');
                  double sumRating =foodModel.rating+updateRating;
                  int ratingCount = foodModel.ratingCount+1;
                  var doc = _firestore.collection(kFoods).document(foodModel.id);
                  doc.updateData({
                    'rating' : sumRating,
                    'ratingCount': ratingCount
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  _getCurrentUser() async {
    _firebaseUser = await _auth.currentUser();
    userId = _firebaseUser.uid;
    //  print(userName);
  }

  Widget _showComment() {
    return Form(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _commentUserController,
              decoration: InputDecoration(hintText: 'Enter Your Comment'),
            ),
            SizedBox(height: 30),
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

  void _commentBottomSheet(BuildContext context, FoodModel foodModel) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StreamBuilder(
            stream: _services.loadComments(foodModel.id),
            builder: (BuildContext context,
                AsyncSnapshot<List<CommentModel>> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  List<CommentModel> commentList = snapshot.data;
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
                StreamBuilder(
                  stream: _services.getUserNameById(commentModel.user_id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('...'),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshot.data[kName].toString(),
                        )
                      ],
                    );
                  },
                ),
                SizedBox(
                  width: 50,
                ),
                Text(commentModel.timeStamp.toDate().toIso8601String())
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

  void addToCart(BuildContext context, FoodModel foodModel) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    foodModel.quantity = _quantity;
    bool exist = false;
    var foodsInCart = cartItem.foods;
    for (var foodInCart in foodsInCart) {
      if (foodInCart.id == foodModel.id) {
        exist = true;
      }
    }
    if (exist) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('The product exist'),
      ));
    } else {
      cartItem.addFood(foodModel);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Added to Cart'),
      ));
    }
  }
}
