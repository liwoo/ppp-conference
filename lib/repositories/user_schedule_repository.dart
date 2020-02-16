import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/models/slot.dart';

abstract class IUserScheduleRepository {
  Future<List<Slot>> fetchDailySlots(DateTime day, String userID);
  void likeSlot(String slotID, String userID);
  void dislikeSlot(String slotID, String userID);
  void bookmarkSlot(String slotID, String userID);
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
        'bookmarks': snap.data['bookmarks'] ?? []
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
}
