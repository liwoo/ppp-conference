import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppp_conference/models/attendee.dart';
import 'package:ppp_conference/repositories/user_schedule_repository.dart';

abstract class IAttendeeRepository {
  Future<List<Attendee>> fetchDelegates();
  Future<List<Attendee>> fetchSpeakers();
  Future<List<Attendee>> fetchFacilitators();
  Future<List<Attendee>> fetchPanelists();
  Future<List<String>> fetchAttendeeSlots(attendeeID);
  Future<void> makeConnectionRequest(userID, attendeeID);
}

class AttendeeRepository implements IAttendeeRepository {
  static const String path = 'attendees';

  final Firestore firestore;

  const AttendeeRepository(this.firestore);

  Future<List<Attendee>> fetchDelegates() async {
    final attendees = await firestore
        .collection(path)
        .where("isDelegate", isEqualTo: true)
        .getDocuments();

    return attendees.documents.map((snap) {
      return Attendee.fromSnapshot(snap);
    }).toList();
  }

  Future<List<Attendee>> fetchSpeakers() async {
    final attendees = await firestore
        .collection(path)
        .where("isSpeaking", isEqualTo: true)
        .getDocuments();

    return attendees.documents.map((snap) {
      return Attendee.fromSnapshot(snap);
    }).toList();
  }

  Future<List<Attendee>> fetchFacilitators() async {
    final attendees = await firestore
        .collection(path)
        .where("isFacilitating", isEqualTo: true)
        .getDocuments();

    return attendees.documents.map((snap) {
      return Attendee.fromSnapshot(snap);
    }).toList();
  }

  Future<List<Attendee>> fetchPanelists() async {
    final attendees = await firestore
        .collection(path)
        .where("isPanelist", isEqualTo: true)
        .getDocuments();

    return attendees.documents.map((snap) {
      return Attendee.fromSnapshot(snap);
    }).toList();
  }

  Future<List<String>> fetchAttendeeSlots(attendeeID) async {
    List<String> slots = [];
    firestore
        .collection(UserScheduleRepository.path)
        .where("slotSpeakers", arrayContains: attendeeID)
        .getDocuments()
        .then((res) {
      res.documents.forEach((snap) {
        slots.add(snap.documentID);
      });
    });
    await firestore
        .collection(UserScheduleRepository.path)
        .where("slotFacilitators", arrayContains: attendeeID)
        .getDocuments()
        .then((res) {
      res.documents.forEach((snap) {
        slots.add(snap.documentID);
      });
    });
    await firestore
        .collection(UserScheduleRepository.path)
        .where("slotPanelists", arrayContains: attendeeID)
        .getDocuments()
        .then((res) {
      res.documents.forEach((snap) {
        slots.add(snap.documentID);
      });
    });

    // Deduplicate
    return slots.toSet().toList();
  }

  Future<void> makeConnectionRequest(userID, attendeeID) {
    // TODO:
  }
}
