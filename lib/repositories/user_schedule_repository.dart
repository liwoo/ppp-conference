import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/models/comment.dart';
import 'package:ppp_conference/models/slot.dart';

abstract class IUserScheduleRepository {
  Future<List<Slot>> fetchDailySlots(DateTime day, String userID);
  Future<List<SlotCategory>> fetchAllCategories();
  Future<List<SlotComment>> fetchSlotComments(String slotID);
  void likeSlot(String slotID, String userID);
  void dislikeSlot(String slotID, String userID);
  void bookmarkSlot(String slotID, String userID);
  void addComment(String comment, String commenter, String slotID);
}

class UserScheduleRepository implements IUserScheduleRepository {
  static const String path = 'slots';

  final Firestore firestore;

  const UserScheduleRepository(this.firestore);

  Future<void> addNewSlot(Slot slot) {
    return firestore.collection(path).document(slot.id).setData(slot.toJson());
  }

  Future<List<Slot>> fetchDailySlots(DateTime day, String userID) async {
    final slots = await firestore
        .collection(path)
        .where("startTime", isGreaterThanOrEqualTo: day)
        .where("startTime", isLessThanOrEqualTo: day.add(Duration(days: 1)))
        .getDocuments();

    return slots.documents.map((doc) {
      return Slot.fromSnapshot(doc, userID);
    }).toList();
  }

  Future<Slot> fetchSlot(String slotID, String userID) async {
    final slot = await firestore
        .collection(path)
        .document(slotID)
        .get()
        .then((DocumentSnapshot snap) {
      return Slot.fromSnapshot(snap, userID);
    });
    return slot;
  }

  _fetchSlotDetails(String slotID, String userID) async {
    return firestore
        .collection(path)
        .document(slotID)
        .get()
        .then((DocumentSnapshot snap) {
      Map<String, dynamic> slot = {
        'likes': snap.data['likes'] ?? [],
        'dislikes': snap.data['dislikes'] ?? [],
        'bookmarks': snap.data['bookmarks'] ?? [],
        'comments': snap.data['comments'] ?? [],
      };
      return slot;
    });
  }

  Future<void> likeSlot(String slotID, String userID) async {
    final slot = await _fetchSlotDetails(slotID, userID);
    if (!slot['likes'].contains(userID)) {
      slot['likes'].add(userID);
      await firestore
          .collection(path)
          .document(slotID)
          .updateData({'likes': slot['likes']});
    }
  }

  Future<void> dislikeSlot(String slotID, String userID) async {
    final slot = await _fetchSlotDetails(slotID, userID);
    if (!slot['dislikes'].contains(userID)) {
      slot['dislikes'].add(userID);
      await firestore
          .collection(path)
          .document(slotID)
          .updateData({'dislikes': slot['dislikes']});
    }
  }

  Future<void> bookmarkSlot(String slotID, String userID) async {
    final slot = await _fetchSlotDetails(slotID, userID);
    if (!slot['bookmarks'].contains(userID)) {
      slot['bookmarks'].add(userID);
      await firestore
          .collection(path)
          .document(slotID)
          .updateData({'bookmarks': slot['bookmarks']});
    }
  }

  @override
  Future<List<SlotCategory>> fetchAllCategories() async {
    final categories = await firestore.collection('/categories').getDocuments();

    return categories.documents.map((category) {
      return SlotCategory.fromReference(category);
    });
  }

  @override
  void addComment(String comment, String commenter, String slotID) async {
    final slot = await _fetchSlotDetails(slotID, commenter);
    var commentDoc = await firestore
        .collection('/comments')
        .add({'comment': comment, 'commenter': commenter, 'slotID': slotID});

    var updatedComments = slot['comments'].add(commentDoc);

    await firestore
        .collection(path)
        .document(slotID)
        .updateData({'comments': updatedComments});
  }

  @override
  Future<List<SlotComment>> fetchSlotComments(String slotID) async {
    final comments = await firestore
        .collection('/comments')
        .where("slotID", isEqualTo: slotID)
        .getDocuments();

    return comments.documents.map((doc) {
      return SlotComment.fromSnapshot(doc);
    }).toList();
  }
}
