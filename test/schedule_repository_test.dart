import 'package:ppp_conference/models/slot.dart';
import 'package:ppp_conference/models/user.dart';
import 'package:ppp_conference/repositories/schedule_repository.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:ppp_conference/repositories/user_repository.dart';
import 'package:test/test.dart';

void main() {
  final firestore = MockFirestoreInstance();
  final userRepository = UserRepository(firestore);
  final repository =
      ScheduleRepository(firestore, userRepository: userRepository);

  final mySlot = Slot(
      id: '1',
      name: "Module 1",
      startTime: DateTime.parse("2020-02-26 08:45:00Z"));
  final mySlot2 = Slot(
      id: '2',
      name: "Module 2",
      startTime: DateTime.parse("2020-02-27 08:45:00Z"));

  addSlot(firestore, mySlot);
  addSlot(firestore, mySlot2);

  test('fetchDailySlots should return a list of slots on given day', () async {
    List<Slot> slots = await repository.fetchDailySlots(
        DateTime.parse("2020-02-26 00:00:00Z"), '1');
    List<Slot> slots2 = await repository.fetchDailySlots(
        DateTime.parse("2020-02-27 00:00:00Z"), '1');

    expect(slots.every((mySlot) {
      return isSameDay(
          DateTime.parse("2020-02-26 00:00:00Z"), mySlot.startTime);
    }), true);
    expect(slots2.every((mySlot) {
      return isSameDay(
          DateTime.parse("2020-02-27 00:00:00Z"), mySlot.startTime);
    }), true);
  });

  test('fetchSlot should return requested slot', () async {
    Slot slot = await repository.fetchSlot('1', '1');
    expect(slot.id, mySlot.id);
    expect(slot.startTime, mySlot.startTime);
  });

  test('likeSlot should adds userID to slot likes', () async {
    await repository.likeSlot('1', '1');
    Slot slot = await repository.fetchSlot('1', '1');
    expect(slot.likes, ['1']);
  });

  test('user should not be able to like slot multiple times', () async {
    await repository.likeSlot('1', '1');
    await repository.likeSlot('1', '1');
    Slot slot = await repository.fetchSlot('1', '1');
    expect(slot.likes, ['1']);
  });

  test('dislikeSlot should adds userID to slot dislikes', () async {
    await repository.dislikeSlot('1', '1');
    Slot slot = await repository.fetchSlot('1', '1');
    expect(slot.dislikes, ['1']);
  });

  test('user should not be able to dislike slot multiple times', () async {
    await repository.dislikeSlot('1', '1');
    await repository.dislikeSlot('1', '1');
    Slot slot = await repository.fetchSlot('1', '1');
    expect(slot.dislikes, ['1']);
  });
  test('bookmarkSlot should adds slotID to users bookmarks', () async {
    await repository.bookmarkSlot('1', '1');
    User user = await userRepository.fetchUser('1');
    expect(user.bookmarks, ['1']);
  });

  test('user should not be able to bookmark slot multiple times', () async {
    await repository.bookmarkSlot('1', '1');
    await repository.bookmarkSlot('1', '1');
    User user = await userRepository.fetchUser('1');
    expect(user.bookmarks, ['1']);
  });
}

addSlot(firestore, slot) async {
  await firestore
      .collection(ScheduleRepository.path)
      .document(slot.id)
      .setData(slot.toJson());
}

isSameDay(DateTime day, DateTime givenDate) {
  DateTime midnight = day.subtract(
      Duration(hours: day.hour, minutes: day.minute, seconds: day.second));
  DateTime nextDay = midnight.add(Duration(days: 1));
  return givenDate.isAfter(midnight) && givenDate.isBefore(nextDay);
}
