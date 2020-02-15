import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/models/user.dart';

abstract class IUserRepository {
  Future<User> fetchUser(userID);
  Future<void> addBookmark(String slotID, String userID);
}

class UserRepository implements IUserRepository {
  static const String path = 'users';

  final Firestore firestore;
  const UserRepository(this.firestore);

  Future<User> fetchUser(userID) async {
    final user = await firestore
        .collection(path)
        .document(userID)
        .get()
        .then((DocumentSnapshot snap) {
      return User.fromSnapshot(snap);
    });
    return user;
  }

  Future<void> addBookmark(String slotID, String userID) async {
    User user = await fetchUser(userID);
    if (!user.bookmarks.contains(slotID)) {
      user.bookmarks.add(slotID);
      await firestore
          .collection(path)
          .document(userID)
          .updateData({'bookmarks': user.bookmarks});
    }
  }
}
