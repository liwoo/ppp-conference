import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitializeAuth extends AuthEvent {
  InitializeAuth() : super([]);
}

class GoogleLogin extends AuthEvent {
  GoogleLogin() : super([]);
}

class PhoneLogin extends AuthEvent {
  final String phoneNumber;
  final BuildContext context;
  PhoneLogin(this.phoneNumber, this.context) : super([phoneNumber, context]);
}

class LoginSuccess extends AuthEvent {
  final FirebaseUser user;
  LoginSuccess(this.user) : super([user]);
}

class MobilePinSent extends AuthEvent {
  final String verificationId;

  MobilePinSent(this.verificationId) : super([verificationId]);
}

class SubmitPin extends AuthEvent {
  final String pin;

  SubmitPin(this.pin) : super([pin]);
}

class Logout extends AuthEvent {
  Logout() : super([]);
}
