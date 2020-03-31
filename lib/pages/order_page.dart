import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/common/Common.dart';
import 'package:flutter_app_food/models/order_model.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderModel> orderList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Order",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('Order')
            .where('user_id', isEqualTo: Common.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              var data = snapshot.data.documents;
              orderList= List<OrderModel>();
              for (var item in data) {
                OrderModel orderModel = OrderModel(
                    item.data['user_id'],
                    item.data['subTotal'],
                    item.data['discount'],
                );
                orderList.add(orderModel);
              }
              return ListView.builder(
                /*padding: EdgeInsets.symmetric(horizontal: 10.0),
                scrollDirection: Axis.vertical,*/
                itemBuilder: (context, position) {
                  return _orderCart(orderList[position]);
                },
                itemCount: orderList.length,
              );
          }
        },
      ),
    );
  }

  Widget _orderCart(OrderModel orderModel) {
    TextStyle textStyle = TextStyle(fontSize: 15, color: Colors.black);
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'subTotal',
                    style: textStyle,
                  ),
                  Text(orderModel.subTotal.toString()),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Discount'),
                  Text(orderModel.discount.toString()),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total'),
                  Text(sumTotal(orderModel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String sumTotal(OrderModel orderModel){
    double subTotal = double.parse(orderModel.subTotal); 
    double discount = double.parse(orderModel.discount);
    double sum = subTotal - discount ;
    return sum.toString();
  }
}
