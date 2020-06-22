import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String id;
  String name;
  String image;
  String category_id;
  String price;
  String discount;
  num rating;
  String description;
  int quantity;
  int ratingCount;

  FoodModel(
      {this.id,
      this.name,
      this.image,
      this.category_id,
      this.price,
      this.discount,
      this.rating,
      this.description,
      this.quantity,
      this.ratingCount});

  FoodModel.fromFirestore(DocumentSnapshot doc)
      : id = doc.data['id'],
        name = doc.data['name'],
        image = doc.data['image'],
        category_id = doc.data['category_id'],
        price = doc.data['price'],
        discount = doc.data['discount'],
        rating = doc.data['rating'],
        description = doc.data['description'],
        ratingCount = doc.data['ratingCount'];
}

List<FoodModel> toFoodModelList(QuerySnapshot query) {
  return query.documents.map((doc) => FoodModel.fromFirestore(doc)).toList();
}
