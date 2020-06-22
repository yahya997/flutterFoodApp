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

String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
  DateTime date = DateTime.parse(dateString);
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? '1 year ago' : 'Last year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} months ago';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? '1 month ago' : 'Last month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}
