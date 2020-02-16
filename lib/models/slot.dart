import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  String id;
  String name;
  String summary;
  DateTime startTime;
  DateTime endTime;
  bool isLiked, isDisliked, isBookmarked;
  String slotCategory;
  List<String> slotFacilitators;
  List<String> slotPanelists;
  List<String> slotSpeaker;
  Slot(
      {this.id,
      this.name,
      this.endTime,
      this.startTime,
      this.summary,
      this.isBookmarked,
      this.isLiked,
      this.isDisliked,
      this.slotCategory,
      this.slotFacilitators,
      this.slotPanelists,
      this.slotSpeaker});

  factory Slot.fromSnapshot(DocumentSnapshot snap, String userId) {
    Timestamp startTimestamp = snap.data['startTime'];
    Timestamp endTimestamp = snap.data['endTime'];
    bool isLiked = snap.data['likes'] != null
        ? snap.data['likes'].contains(userId)
        : false;
    bool isDisliked = snap.data['dislikes'] != null
        ? snap.data['dislikes'].contains(userId)
        : false;
    bool isBookmarked = snap.data['bookmarks'] != null
        ? snap.data['bookmarks'].contains(userId)
        : false;
    return Slot(
        id: snap.documentID,
        name: snap.data['name'] ?? '',
        summary: snap.data['summary'] ?? '',
        slotCategory: snap.data['slotCategory'] ?? '',
        slotFacilitators: snap.data['slotFacilitators'] ?? [],
        slotPanelists: snap.data['slotPanelists'] ?? [],
        slotSpeaker: snap.data['slotSpeaker'] ?? [],
        isBookmarked: isBookmarked,
        isLiked: isLiked,
        isDisliked: isDisliked,
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
      'slotCategory': slotCategory,
      'likes': [],
      'dislikes': [],
      'bookmarks': [],
      'slotFacilitators': [],
      'slotPanelists': [],
      'slotSpeaker': [],
    };
  }

  @override
  String toString() {
    return "id: $id, name: $name, endTime: $endTime, startTime: $startTime, summary: $summary, slotCategory: $slotCategory, isLiked: $isLiked, isDisliked: $isDisliked, isBookmarked: $isBookmarked";
  }
}
