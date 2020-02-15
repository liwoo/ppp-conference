import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum SocialLoginMethod { apple, facebook, google }
enum MobileLoginState { codeSent, autoRetrieved, complete, failed }

class MobileLogin {
  MobileLoginState state;
  FirebaseUser user;
  String verificationId;
  String error;
  MobileLogin({this.user, this.state, this.verificationId, this.error});
  @override
  String toString() {
    var stateString;
    switch (state) {
      case MobileLoginState.codeSent:
        stateString = 'Code Sent';
        break;
      case MobileLoginState.autoRetrieved:
        stateString = 'Auto Retrieved';
        break;
      case MobileLoginState.complete:
        stateString = 'Complete';
        break;
      case MobileLoginState.failed:
        stateString = 'Failed';
        break;
      default:
        stateString = 'Pending';
    }
    return "state: $stateString, user: $user, error: $error, verificationId: $verificationId";
  }
}

abstract class IAuthRepository {
  Future<FirebaseUser> socialLogin(SocialLoginMethod method);
  Stream<MobileLogin> requestMobileLoginPin(String phoneNumber);
  Future<FirebaseUser> mobileLogin(String verificationId, String smsCode);
  Future<void> logout(userID);
}

class AuthRepository implements IAuthRepository {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  const AuthRepository(this.auth, {this.googleSignIn});
  Future<FirebaseUser> socialLogin(SocialLoginMethod method) async {
    AuthCredential credential;
    switch (method) {
      case SocialLoginMethod.google:
        final GoogleSignInAccount googleUser =
            await googleSignIn.signIn().catchError((e) {
          return Future.error(e);
        });
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        break;
      default:
    }
    final FirebaseUser user =
        (await auth.signInWithCredential(credential)).user;
    return user;
  }

  Stream<MobileLogin> requestMobileLoginPin(String phoneNumber) {
    var controller = StreamController<MobileLogin>();
    AuthResult res;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      controller.add(MobileLogin(
          state: MobileLoginState.autoRetrieved, verificationId: verId));
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      controller.add(
          MobileLogin(state: MobileLoginState.codeSent, verificationId: verId));
    };
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      res = await auth.signInWithCredential(phoneAuthCredential);
      print(res);
      controller
          .add(MobileLogin(state: MobileLoginState.complete, user: res.user));
      controller.close();
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      controller.add(MobileLogin(
          state: MobileLoginState.failed, error: authException.message));
      controller.close();
    };
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
    return controller.stream;
  }

  Future<FirebaseUser> mobileLogin(
      String verificationId, String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      final AuthResult res = await auth.signInWithCredential(credential);
      return res.user;
    } catch (e) {
      if (e is PlatformException) {
        switch (e.code) {
          case 'ERROR_INVALID_VERIFICATION_CODE':
            return Future.error('Invalid code, please try again');
            break;
          default:
            return Future.error('An Error occured...');
        }
      }
      return Future.error('An Error occured...');
    }
  }

  Future<void> logout(userID) async {
    return auth.signOut();
  }
}
