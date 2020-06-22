import 'package:flutter/material.dart';

//const Color primaryColor = Color(0xFF503E9D);
//const Color primaryColorLight = Color(0xFF6252A7);
const Color primaryColor = Color(0xFFFFC12F);
const Color primaryColorLight = Color(0xFFFFE6Ac);
const kUnActiveColor = Color(0xFFC1BDB8);
const red = Colors.red;
const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Colors.grey;
const Color green = Colors.green;

const kPopular = 'Popular';
const kCategory = 'Category';
const kUser = 'User';
const kName = 'name';
const kAddress = 'address';
const kTotalPrice = 'TotalPrice';
const kPhone = 'phone';
const kFoods = 'Foods';
const kComment = 'Comment';
const kOrder = 'Order';
const kOrderDetails = 'OrderDetails';
const kUserId = 'userId';

 double checkDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else {
    return value;
  }
}
