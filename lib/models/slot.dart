import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {
  String id;
  String name;
  String summary;
  String summaryHTML;
  DateTime startTime;
  DateTime endTime;
  int comments;
  bool isLiked, isDisliked, isBookmarked;
  Future<DocumentSnapshot> category;
  List<DocumentReference> slotFacilitators;
  List<Future<DocumentSnapshot>> slotPanelists;
  List<DocumentReference> slotSpeakers;
  Slot(
      {this.id,
      this.name,
      this.endTime,
      this.startTime,
      this.summary,
      this.isBookmarked,
        this.comments,
      this.isLiked,
      this.isDisliked,
      this.category,
        this.summaryHTML,
      this.slotFacilitators,
      this.slotPanelists,
      this.slotSpeakers});

  factory Slot.fromSnapshot(DocumentSnapshot snap, String userId) {
    Timestamp startTimestamp = snap.data['startTime'];
    Timestamp endTimestamp = snap.data['endTime'];
    var facilitators = snap.data['slotFacilitators'] != null ? snap.data['slotFacilitators'].cast<DocumentReference>() : null;
    var speakers = snap.data['slotSpeakers'] != null ? snap.data['slotSpeakers'].cast<DocumentReference>() : null;
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
        summaryHTML: snap.data['summaryHTML'] ?? '',
        category: snap.data['category'].get() ?? '',
        slotFacilitators: facilitators,
        slotPanelists: snap.data['slotPanelists'],
        comments: snap.data['comments'] ?? 0,
        slotSpeakers: speakers,
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
      'category': category,
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
    return "id: $id, name: $name, endTime: $endTime, startTime: $startTime, summary: $summary, slotCategory: $category, isLiked: $isLiked, isDisliked: $isDisliked, isBookmarked: $isBookmarked";
  }
}

class SlotCategory {
  String name;
  String description;
  String color;

  SlotCategory({this.name, this.description, this.color});

  factory SlotCategory.fromReference(DocumentSnapshot snap) {
    return SlotCategory(
        name: snap.data['name'] ?? 'No Name Proviced',
        description: snap.data['description'] ?? 'No Description Provided',
        color: snap.data['color'] ?? 'ffffff');
  }
}
