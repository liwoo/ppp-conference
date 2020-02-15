import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/models/user.dart';

class Slot {
  String id;
  String name;
  String summary;
  DateTime startTime;
  DateTime endTime;
  User user;
  List<String> likes;
  List<String> dislikes;
  Slot(
      {this.id,
      this.name,
      this.endTime,
      this.startTime,
      this.summary,
      this.user,
      this.likes,
      this.dislikes});

  factory Slot.fromSnapshot(DocumentSnapshot snap) {
    Timestamp startTimestamp = snap.data['startTime'];
    Timestamp endTimestamp = snap.data['endTime'];
    return Slot(
        id: snap.documentID,
        name: snap.data['name'],
        summary: snap.data['summary'],
        user: snap.data['user'],
        likes: snap.data['likes'] ?? [],
        dislikes: snap.data['dislikes'] ?? [],
        endTime: endTimestamp != null ? endTimestamp.toDate().toUtc() : null,
        startTime:
            startTimestamp != null ? startTimestamp.toDate().toUtc() : null);
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'endTime': endTime != null ? Timestamp.fromDate(endTime) : null,
      'startTime': startTime != null ? Timestamp.fromDate(startTime) : null,
      'summary': summary,
      'likes': likes,
      'dislikes': dislikes,
      'user': user
    };
  }

  @override
  String toString() {
    return "id: $id, name: $name, endTime: $endTime, startTime: $startTime, summary: $summary, user: $user, likes: $likes, dislikes: $dislikes";
  }
}
