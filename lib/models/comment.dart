
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotComment {
  String commenterID;
  String comment;
  String commenter;
  String commenterImage;
  DateTime time;

  SlotComment({this.comment, this.commenterID, this.commenter, this.commenterImage, this.time});

  factory SlotComment.fromSnapshot(DocumentSnapshot snap) {
    Timestamp time = snap.data['time'];
    return SlotComment(
      commenterID: snap.data['commenterID'] ?? '',
      comment: snap.data['comment'] ?? '',
      commenter: snap.data['commenter'] ?? '',
      commenterImage: snap.data['commenterImage'] ?? '',
      time: time != null ? time.toDate().toUtc() : DateTime.now()
    );
  }
}