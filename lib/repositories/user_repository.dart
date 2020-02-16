import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';

abstract class IUserRepository {
  Future<List<String>> connectionRequestsMade(userID);
  Future<List<String>> likedSlots(userID);
  Future<List<String>> dislikedSlots(userID);
  Future<List<String>> bookmarkedSlots(userID);
  Future<List<String>> connectionRequestsReceived(userID);
  Future<bool> isRegistered(userID);
}

class UserRepository implements IUserRepository {
  static const String path = 'attendees';

  final Firestore firestore;
  const UserRepository(this.firestore);

  Future<bool> isRegistered(userID) async {
    return firestore.collection(path).document(userID).get().then((res) {
      return res.exists;
    });
  }

  Future<List<String>> likedSlots(userID) async {
    return firestore
        .collection(UserScheduleRepository.path)
        .where('likes', arrayContains: userID)
        .getDocuments()
        .then((QuerySnapshot snap) {
      List<String> liked = snap.documents.map((DocumentSnapshot doc) {
        return doc.documentID;
      }).toList();
      return liked;
    });
  }

  Future<List<String>> dislikedSlots(userID) async {
    return firestore
        .collection(UserScheduleRepository.path)
        .where('dislikes', arrayContains: userID)
        .getDocuments()
        .then((QuerySnapshot snap) {
      List<String> liked = snap.documents.map((DocumentSnapshot doc) {
        return doc.documentID;
      }).toList();
      return liked;
    });
  }

  Future<List<String>> bookmarkedSlots(userID) async {
    return firestore
        .collection(UserScheduleRepository.path)
        .where('bookmarks', arrayContains: userID)
        .getDocuments()
        .then((QuerySnapshot snap) {
      List<String> liked = snap.documents.map((DocumentSnapshot doc) {
        return doc.documentID;
      }).toList();
      return liked;
    });
  }

  connectionRequestsMade(userID) async {
    // TODO:
  }

  Future<List<String>> connectionRequestsReceived(userID) {
    // TODO:
  }
}
