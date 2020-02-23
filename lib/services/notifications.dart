import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ppp_conference/models/pp_notification.dart';
// import 'package:ppp_conference/models/pp_notification.dart';

abstract class IPushNotificationService {
  void unsubscribeFromAll();
  void unsubscribeFromTopic(String topic);
  Stream<PPNotification> subscribeToTopic(String topic);
}

class NotificationService implements IPushNotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamController<PPNotification> controller = StreamController();

  Stream<PPNotification> subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
    if (Platform.isIOS) iosPermission();

    _firebaseMessaging.getToken().then(print);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var notification = PPNotification.fromMap(message);
        print("On Message: $notification");
        controller.add(notification);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        controller.add(PPNotification.fromMap(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        controller.add(PPNotification.fromMap(message));
      },
    );
    return controller.stream;
  }

  void unsubscribeFromAll() {
    _firebaseMessaging.deleteInstanceID();
  }

  void unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic.replaceFirst('@', '_at_'));
  }

  void iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
