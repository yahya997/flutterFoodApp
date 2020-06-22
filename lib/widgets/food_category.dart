import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_food/models/category_model.dart';
import 'package:flutter_app_food/services/services.dart';
import 'package:flutter_app_food/widgets/single_category.dart';

class FoodCategory extends StatelessWidget {
  List<DocumentSnapshot> _categories;
  final _services = Services();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _services.loadCategory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading ...');
          default:
            return Container(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  CategoryModel categoryModel = CategoryModel(
                      document['id'], document['name'], document['image']);
                  return SingleCategory(
                    categoryModel: categoryModel,
                  );
                }).toList(),
              ),
            );
        }
      },
    );
  }
}
