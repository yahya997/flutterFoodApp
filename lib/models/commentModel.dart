import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel{
  String food_id,user_id,comment,rating;
  Timestamp timeStamp;

  CommentModel(this.food_id, this.user_id, this.comment, this.rating,
      this.timeStamp);


}