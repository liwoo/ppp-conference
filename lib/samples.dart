import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ppp_conference/models/pp_notification.dart';
import 'package:ppp_conference/repositories/auth_repository.dart';
import 'package:ppp_conference/services/notifications.dart';
import 'package:http/http.dart' as http;

class Sample extends StatefulWidget {
  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  String verificationId;
  FirebaseUser user;
  FirebaseAuth firebaseAuth;
  IPushNotificationService notificationService;
  IAuthRepository auth;
  Stream<PPNotification> notificationStream;
  bool listening = false;
  @override
  void initState() {
    firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    auth = AuthRepository(firebaseAuth, googleSignIn: googleSignIn);
    notificationService = NotificationService();
    super.initState();
  }

  void googleSignin() async {
    user = await auth.socialLogin(SocialLoginMethod.google);
    print(user.displayName);
  }

  void verifyCode() async {
    if (verificationId != null) {
      try {
        user = await auth.mobileLogin(verificationId, "123456");
        print('Successful Sign in, user: $user');
      } catch (e) {
        print('verification error: $e');
      }
    }
  }

  void verifyIncorrectCode() async {
    if (verificationId != null) {
      try {
        user = await auth.mobileLogin(verificationId, "123457");
        print('Successful Sign in, user: $user');
      } catch (e) {
        print('verification error: $e');
      }
    }
  }

  void requestMobileLogin() async {
    Stream<MobileLogin> mobileLogin =
        auth.requestMobileLoginPin("+16505551234");
    mobileLogin.listen((data) {
      switch (data.state) {
        case MobileLoginState.codeSent:
          setState(() {
            verificationId = data.verificationId;
          });
          print('code sent, VerificationId: ${data.verificationId}');
          break;
        case MobileLoginState.autoRetrieved:
          setState(() {
            verificationId = data.verificationId;
          });
          print('Auto Retrieved, VerificationId: ${data.verificationId}');
          break;
        case MobileLoginState.complete:
          user = data.user;
          print('Sign in complete, user: ${data.user.phoneNumber}');
          break;
        default:
          print(data);
      }
    });
  }

  void subscribeNotification() {
    notificationStream = notificationService.subscribeToTopic("topic");
    if (!listening) {
      notificationStream.listen((notification) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(notification.title),
                  content: Text(notification.body));
            });
      });
      print('subscribed');
      listening = true;
    }
  }

  void unsubscribe() {
    notificationService.unsubscribeFromTopic("topic");
    print('unsubscribed');
  }

  void unsubscribeAll() {
    notificationService.unsubscribeFromAll();
    print('unsubscribed');
  }

  Future<void> sendNotification() async {
    final String serverToken = '<server token>';
    print('sending notification');
    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/topic",
        },
      ),
    );
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Auth Samples",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              child: Text("Google Login"),
              onPressed: googleSignin,
            ),
            OutlineButton(
              child: Text("Request Phone"),
              onPressed: requestMobileLogin,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              child: Text("Verify Code"),
              onPressed: verifyCode,
            ),
            OutlineButton(
              child: Text("Incorrect Code"),
              onPressed: verifyIncorrectCode,
            ),
          ],
        ),
        Divider(
          thickness: 5,
        ),
        Text(
          "Notification Samples",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              child: Text("Subscribe Topic"),
              onPressed: subscribeNotification,
            ),
            OutlineButton(
              child: Text("Unsubscribe Topic"),
              onPressed: unsubscribe,
            ),
          ],
        ),
        OutlineButton(
          child: Text("Unsubscribe All"),
          onPressed: unsubscribeAll,
        ),
        OutlineButton(
          child: Text("Send Notification"),
          onPressed: sendNotification,
        ),
      ],
    );
  }
}
