import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String profilePic;
  String country;
  String title;
  String company;
  List<String> bookmarks;
  User(
      {this.company,
      this.country,
      this.email,
      this.id,
      this.name,
      this.profilePic,
      this.bookmarks,
      this.title});

  factory User.fromSnapshot(DocumentSnapshot snap) {
    return User(
        id: snap.documentID,
        name: snap.data['name'] ?? '',
        email: snap.data['email'] ?? '',
        profilePic: snap.data['profilePic'] ?? '',
        country: snap.data['country'] ?? '',
        title: snap.data['title'] ?? '',
        company: snap.data['company'] ?? '',
        bookmarks: snap.data['bookmarks'] ?? []);
  }
}
