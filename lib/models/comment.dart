
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotComment {
  String comment;
  String commenter;
  String commenterImage;
  DateTime time;

  SlotComment({this.comment, this.commenter, this.commenterImage, this.time});

  factory SlotComment.fromSnapshot(DocumentSnapshot snap) {
    return SlotComment(
      comment: snap.data['comment'] ?? '',
      commenter: snap.data['comment'] ?? '',
      commenterImage: snap.data['commenterImage'] ?? '',
      time: snap.data['time'] ?? DateTime(2020, 2, 24, 8, 0)
    );
  }
}