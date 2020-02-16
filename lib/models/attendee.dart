import 'package:cloud_firestore/cloud_firestore.dart';

class Attendee {
  String id;
  String fullName;
  String occupation;
  String organization;
  String country;
  String profile;
  List<SocialMedia> socialMedia;
  Attendee(
      {this.id,
      this.fullName,
      this.occupation,
      this.organization,
      this.country,
      this.profile,
      this.socialMedia});

  factory Attendee.fromSnapshot(DocumentSnapshot snap) {
    List<Map<String, dynamic>> socials =
        snap.data['socialMedia'] != null ? snap.data['socialMedia'] : [];
    List<SocialMedia> socialMedia = socials.map((social) {
      return SocialMedia.fromJson(social);
    }).toList();
    return Attendee(
        id: snap.documentID,
        fullName: snap.data['fullName'] ?? '',
        occupation: snap.data['occupation'] ?? '',
        organization: snap.data['organization'] ?? '',
        country: snap.data['country'] ?? '',
        profile: snap.data['profile'] ?? '',
        socialMedia: socialMedia);
  }
}

class SocialMedia {
  String platform;
  String username;
  String url;
  SocialMedia({this.platform, this.url, this.username});
  factory SocialMedia.fromJson(json) {
    return SocialMedia(
        platform: json['platform'],
        username: json['username'],
        url: json['url']);
  }
}
