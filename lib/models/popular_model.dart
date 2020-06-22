import 'package:cloud_firestore/cloud_firestore.dart';

class PopularModel {
  String id;
  String name;
  String image;
  String price;
  String discount;
  num rating;
  String description;
  int quantity;
  int ratingCount;

  PopularModel(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.discount,
      this.rating,
      this.description,
      this.quantity,
      this.ratingCount});

  PopularModel.fromFirestore(DocumentSnapshot doc)
      : id = doc.data['id'],
        name = doc.data['name'],
        image = doc.data['image'],
        price = doc.data['price'],
        discount = doc.data['discount'],
        rating = doc.data['rating'],
        description = doc.data['description'],
        ratingCount = doc.data['ratingCount'];
}

List<PopularModel> toPopularModelList(QuerySnapshot query) {
  return query.documents.map((doc) => PopularModel.fromFirestore(doc)).toList();
}
