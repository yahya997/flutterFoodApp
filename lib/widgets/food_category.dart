import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'food_card.dart';

class FoodCategory extends StatelessWidget {
   List<DocumentSnapshot> _categories;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Category').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading ...');
          default:
            return Container(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return FoodCard(
                      categoryName: document['name'],
                      imagePath: document['image'],
                      id: document['id'],
                    ) ;
                }).toList(),
              ),
            );
        }
      },
    );
  }
}
