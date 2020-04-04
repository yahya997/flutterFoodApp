import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/common/Common.dart';
import 'package:flutter_app_food/models/cartModel.dart';
import '../widgets/cart_card.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModel> cartList;
  CartModel cartModel;
  FirebaseAuth _auth;
  FirebaseUser _firebaseUser;
  String userId;
  double subTotal=0.0;
  double discountTotal=0.0;
  @override
  void initState() {
    _getSubTotal();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Cart')
          .where('user_id', isEqualTo: userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            var data = snapshot.data.documents;
            cartList = List<CartModel>();
            for (var item in data) {
               cartModel = CartModel(
                  item.data['food_id'],
                  item.data['user_id'],
                  item.data['documentID'],
                  item.data['name'],
                  item.data['image'],
                  item.data['price'],
                  item.data['discount'],
                  item.data['quantity'],
                  item.data['priceTotal']);
              cartList.add(cartModel);
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Your Food Cart",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                centerTitle: true,
              ),
              body: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  return _orderCart(cartList[position]);
                },
                itemCount: cartList.length,
              ),
              bottomNavigationBar: _buildTotalContainer(),
            );
        }
      },
    );
  }

  Widget _buildTotalContainer() {
    return Container(
      height: 220.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Subtotal",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                subTotal.toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Discount",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                discountTotal.toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tax",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "0.5",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Cart Total",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                (subTotal - discountTotal).toString(),
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignInPage()));
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: (){
                      Firestore.instance.collection('Order').document().setData(
                        {
                          'user_id' : Common.userId,
                          'subTotal' :subTotal.toString(),
                          'discount' : discountTotal.toString(),
                        }
                      ).then((value) {
                        String document;
                        Firestore.instance.collection('Cart').where('user_id' , isEqualTo: Common.userId).getDocuments().then((value) {
                          for(var item in value.documents){
                             document = item.data['documentID'];
                             Firestore.instance.collection('Cart').document(document).delete();
                          }
                        });
                      });
                  },
                  child: Text(
                    "Proceed To Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  _orderCart(CartModel cartModel) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 45.0,
              height: 73.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          int quantityPlus = int.parse(cartModel.quantity) + 1;
                          Firestore.instance
                              .collection('Cart')
                              .document(cartModel.documentID)
                              .updateData({
                            "quantity": quantityPlus.toString()
                          }).then((value) {
                            _updateTotalPrice(cartModel, quantityPlus);
                            subTotal = 0;
                            discountTotal =0;
                            _getSubTotal();
                          });
                        },
                        child: Icon(Icons.keyboard_arrow_up,
                            color: Color(0xFFD3D3D3))),
                    Text(
                      cartModel.quantity,
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () {
                          int quantitySub = int.parse(cartModel.quantity) - 1;
                          if (quantitySub <= 0)
                            print('Error');
                          else {
                            Firestore.instance
                                .collection('Cart')
                                .document(cartModel.documentID)
                                .updateData({
                              "quantity": quantitySub.toString()
                            }).then((value) {
                              _updateTotalPrice(cartModel, quantitySub);
                              subTotal = 0;
                              discountTotal=0;
                              _getSubTotal();
                            });
                          }
                        },
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFD3D3D3))),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 70.0,
              width: 70.0,
              child: Image.network(
                cartModel.image,
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 2.0))
                  ]),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cartModel.name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "\u023B ${cartModel.price}",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 25.0,
                  width: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Chicken",
                              style: TextStyle(
                                  color: Color(0xFFD3D3D3),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "x",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Firestore.instance
                    .collection('Cart')
                    .document(cartModel.documentID)
                    .delete();
              },
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentUser() async {
    _firebaseUser = await _auth.currentUser();
    userId = _firebaseUser.uid;
  }

  _updateTotalPrice(CartModel cartModel, int newQuantity) {
    int price = int.parse(cartModel.price);
    //int discount = int.parse(cartModel.discount);
    int quantity = newQuantity;
    //int totalDiscount = discount * quantity;
    int totalPrice = price * quantity;
    int priceWithDiscount = totalPrice;
    Firestore.instance
        .collection('Cart')
        .document(cartModel.documentID)
        .updateData({"priceTotal": priceWithDiscount.toString()}).then(
            (value) {
              print('update ${priceWithDiscount.toString()}');
            });
  }

     _getSubTotal()  {
     Firestore.instance.collection('Cart').getDocuments().then((value) {
      //print(value.documents);
      for(var item in value.documents) {
        String getPriceTotal = item.data['priceTotal'];
        String getDiscount = item.data['discount'];
        String getQuantity = item.data['quantity'];
        double priceTotal = double.parse(getPriceTotal);
        double discount = double.parse(getDiscount);
        double quantity = double.parse(getQuantity);
        double discountWithQuantity = discount * quantity;
        discountTotal +=discountWithQuantity;
        subTotal +=priceTotal;
      }
    });

    }
  }


