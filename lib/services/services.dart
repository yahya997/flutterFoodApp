import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_food/const.dart';
import 'package:flutter_app_food/models/comment_model.dart';
import 'package:flutter_app_food/models/food_model.dart';
import 'package:flutter_app_food/models/popular_model.dart';
import 'package:flutter_app_food/models/user_model.dart';

class Services {
  final Firestore _firestore = Firestore.instance;

  Stream<DocumentSnapshot> getUserNameById(userId) {
    return _firestore.collection(kUser).document(userId).snapshots();
  }

  editUser(userId, data) {
    var documentRef = _firestore.collection(kUser).document(userId);
    documentRef.setData(data);
  }

  Stream<List<FoodModel>> loadPopularProduct() {
    return _firestore.collection(kPopular).snapshots().map(toFoodModelList);
  }

  Stream<QuerySnapshot> loadCategory() {
    return _firestore.collection(kCategory).snapshots();
  }

  storeUsers(uid, data) {
    var documentRef = _firestore.collection(kUser).document(uid);
    documentRef.setData(data);
  }

  storeRatingToFirestore(food_id,rating){
    var documentRef= _firestore.collection(kFoods).document(food_id);
    documentRef.updateData(rating);
  }

  Stream<List<FoodModel>> loadFoods(category_id) {
    return _firestore
        .collection(kFoods)
        .where('category_id', isEqualTo: category_id)
        .snapshots()
        .map(toFoodModelList);
  }

  Stream<List<FoodModel>> loadFoodsByName(foodName) {
    return _firestore
        .collection(kFoods)
        .where(kName, isEqualTo: foodName)
        .snapshots()
        .map(toFoodModelList);
  }

  Stream<List<CommentModel>> loadComments(food_id) {
    return _firestore
        .collection(kComment)
        .where('food_id', isEqualTo: food_id)
        .snapshots()
        .map(toCommentModelList);
  }

 /* storeComment(data) {
    var documentRef = _firestore.collection(kComment).document();
    documentRef.setData(data);
  }*/

  Stream<QuerySnapshot> loadOrders(userId) {
    return _firestore.collection(kOrder).where('userId',isEqualTo: userId).snapshots();
  }

  storeOrders(data, List<FoodModel> foods) {
    var documentRef = _firestore.collection(kOrder).document();
    documentRef.setData(data);
    for (var food in foods)
      documentRef.collection(kOrderDetails).document().setData({
        'id': food.id,
        'category_id': food.category_id,
        'name': food.name,
        'price': food.price,
        'discount': food.discount,
        'description': food.description,
        'quantity': food.quantity,
        'image': food.image,
      });
  }
}
