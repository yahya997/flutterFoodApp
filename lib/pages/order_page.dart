import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/models/order_model.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_app_food/stores/login_store.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  static String id = 'OrdersScreen';
  final Services _services = Services();


  @override
  Widget build(BuildContext context) {
    String userId= Provider.of<LoginStore>(context).firebaseUser.uid;
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: _services.loadOrders(userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('There is no orders'),
              );
            } else {
              List<OrderModel> orders = [];
              for (var doc in snapshot.data.documents) {
                OrderModel order = OrderModel(
                    documentId: doc.documentID,
                    address: doc.data[kAddress],
                    totalPrice: doc.data[kTotalPrice]);
                orders.add(order);
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * .12,
                          color: primaryColorLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Total Price = \$${orders[index].totalPrice}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Address is : ${orders[index].address}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}