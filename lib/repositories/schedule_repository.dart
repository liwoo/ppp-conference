import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/repositories/user_repository.dart';

abstract class IScheduleRepository {
  Future<List<Slot>> fetchDailySlots(DateTime day, String userID);
  Future<Slot> fetchSlot(String slotID, String userID);
  void likeSlot(String slotID, String userID);
  void dislikeSlot(String slotID, String userID);
  void bookmarkSlot(String slotID, String userID);
}

class ScheduleRepository implements IScheduleRepository {
  static const String path = 'slots';

  final Firestore firestore;
  final IUserRepository userRepository;

  const ScheduleRepository(this.firestore, {this.userRepository});

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
      return Slot.fromSnapshot(doc);
    }).toList();
  }

  Future<Slot> fetchSlot(String slotID, String userID) async {
    final slot = await firestore
        .collection(path)
        .document(slotID)
        .get()
        .then((DocumentSnapshot snap) {
      return Slot.fromSnapshot(snap);
    });
    return slot;
  }

  Future<void> likeSlot(String slotID, String userID) async {
    final slot = await fetchSlot(slotID, userID);
    if (!slot.likes.contains(userID)) {
      slot.likes.add(userID);
      await firestore
          .collection(path)
          .document(slotID)
          .updateData({'likes': slot.likes});
    }
  }

  Future<void> dislikeSlot(String slotID, String userID) async {
    final slot = await fetchSlot(slotID, userID);
    if (!slot.dislikes.contains(userID)) {
      slot.dislikes.add(userID);
      await firestore
          .collection(path)
          .document(slotID)
          .updateData({'dislikes': slot.dislikes});
    }
  }

  Future<void> bookmarkSlot(String slotID, String userID) async {
    await userRepository.addBookmark(slotID, userID);
    // TODO: subscribes to a slot_id_topic;
  }
}
