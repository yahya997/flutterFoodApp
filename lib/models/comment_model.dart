import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String food_id, user_id, comment, rating;
  Timestamp timeStamp;



  CommentModel.fromFirestore(DocumentSnapshot doc)
      : food_id = doc.data['food_id'],
        user_id = doc.data['userId'],
        comment = doc.data['comment'],
        rating = doc.data['rating'],
        timeStamp = doc.data['timeStamp'];
}
List<CommentModel> toCommentModelList (QuerySnapshot query){
  return query.documents.map((doc) => CommentModel.fromFirestore(doc)).toList();
}