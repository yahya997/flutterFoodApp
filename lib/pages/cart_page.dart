import 'package:flutter/material.dart';
import 'package:flutter_app_food/const.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/provider/cart_item.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_app_food/stores/login_store.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    List<FoodModel> foods = Provider.of<CartItem>(context).foods;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if(foods.isNotEmpty){
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return _orderCart(foods[position]);
              },
              itemCount: foods.length,
            );
          }else{
            return Container(
              child: Center(
                child: Text('Cart is Empty'),
              ),
            );
          }

        },
      ),
      bottomNavigationBar: _buildTotalContainer(foods),
    );
  }

  Widget _buildTotalContainer( List<FoodModel> foods) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Total:', style: TextStyle(fontSize: 20)),
            Spacer(),
            Chip(
              label: Text(
                '\$${getTotalPrice(foods).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.title.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            FlatButton(
              onPressed: (){
                showCustomDialog(foods, context);

              },
              child: Text("ORDER NOW"),
              textColor: primaryColorLight,
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(List<FoodModel> foods, context) async {

    var price = getTotalPrice(foods);
    var address ;
    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[
        MaterialButton(onPressed:(){
          try {
            String userId= Provider.of<LoginStore>(context,listen: false).firebaseUser.uid;
            Services _services = Services();
            _services.storeOrders(
                {kUserId:userId,kTotalPrice: price, kAddress: address}, foods);

            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Orderd Successfully'),
            ));
            Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteAllFood();

          } catch (ex) {
            print(ex.message);
          }
        },

          child: Text('Confirm'),
        )
      ],
      content: TextField(
        onChanged: (value){
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter Your Address'),
      ),
      title: Text('Total Price = \$ $price'),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalPrice(List<FoodModel> foodModel) {
    var price = 0;
    for (var food in foodModel) {
      price += food.quantity * int.parse(food.price);
    }
    return price;
  }

  _orderCart(FoodModel foodModel) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 70.0,
              child: Image.network(
                foodModel.image,
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
                  foodModel.name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "\$ ${foodModel.price}",
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
                          Text("Quantity",
                              style: TextStyle(
                                  color: Color(0xFFD3D3D3),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              foodModel.quantity.toString(),
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
                Provider.of<CartItem>(context, listen: false)
                    .deleteFood(foodModel);
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
}
