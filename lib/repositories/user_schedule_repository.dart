import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:ppp_conference/models/comment.dart';
import 'package:ppp_conference/models/slot.dart';

abstract class IUserScheduleRepository {
  Future<List<Slot>> fetchDailySlots(DateTime day, String userID);
  Future<List<SlotCategory>> fetchAllCategories();
  Future<List<SlotComment>> fetchSlotComments(String slotID);
  Future<void> likeSlot(String slotID, String userID);
  Future<void> dislikeSlot(String slotID, String userID);
  Future<void> bookmarkSlot(String slotID, String userID);
  Future<void> addComment(String comment, String commenter, String slotID, String commenterID);
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
    List likes = slot['likes'];
    if (!likes.contains(userID)) {
      likes.add(userID);
    } else
      likes.remove(userID);
    await firestore
        .collection(path)
        .document(slotID)
        .updateData({'likes': likes});
  }

  Future<void> dislikeSlot(String slotID, String userID) async {
    final slot = await _fetchSlotDetails(slotID, userID);
    List dislikes = slot['dislikes'];

    if (!dislikes.contains(userID))
      dislikes.add(userID);
    else
      dislikes.remove(userID);
    await firestore
        .collection(path)
        .document(slotID)
        .updateData({'dislikes': dislikes});
  }

  Future<void> bookmarkSlot(String slotID, String userID) async {
    final slot = await _fetchSlotDetails(slotID, userID);
    List bookmarks = slot['bookmarks'];
    if (!bookmarks.contains(userID))
      bookmarks.add(userID);
    else
      bookmarks.remove(userID);
    await firestore
        .collection(path)
        .document(slotID)
        .updateData({'bookmarks': bookmarks});
  }

  @override
  Future<List<SlotCategory>> fetchAllCategories() async {
    final categories = await firestore.collection('/categories').getDocuments();

    return categories.documents.map((category) {
      return SlotCategory.fromReference(category);
    });
  }

  @override
  Future<void> addComment(String comment, String commenter, String slotID, String commenterID) async {
    await firestore
        .collection('/comments')
        .add({'comment': comment, 'commenter': commenter, 'slotID': slotID, commenterID: commenterID, 'time': DateTime.now()});
    final slot = await _fetchSlotDetails(slotID, commenterID);
    var documentComments = slot['comments'] ?? [];
    await firestore
        .collection(path)
        .document(slotID)
        .updateData({'comments': documentComments.length += 1});
  }


  @override
  Future<List<SlotComment>> fetchSlotComments(String slotID) async {
    final comments = await firestore
        .collection('/comments')
        .where("slotID", isEqualTo: slotID)
        .getDocuments();

    if(comments.documents.length == 0) {
      return [];
    }

    return comments.documents.map((doc) {
      return SlotComment.fromSnapshot(doc);
    }).toList();
  }
}
