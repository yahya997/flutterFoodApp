import 'package:flutter/cupertino.dart';
import 'package:flutter_app_food/models/food_model.dart';

class CartItem with ChangeNotifier {
  List<FoodModel> foods = [];

  addFood(FoodModel foodModel) {
    foods.add(foodModel);

    notifyListeners();
  }

  deleteFood(FoodModel foodModel) {
    foods.remove(foodModel);
    notifyListeners();
  }
  deleteAllFood(){
    foods.clear();
    notifyListeners();
  }
}
