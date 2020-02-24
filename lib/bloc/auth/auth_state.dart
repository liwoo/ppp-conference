import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]);

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {
  @override
  String toString() {
    return 'Loading Auth...';
  }

  @override
  List<Object> get props => [];
}

class MobilePinSentState extends AuthState {
  final String verificationId;

  MobilePinSentState(this.verificationId) : super([verificationId]);

  @override
  List<Object> get props => [verificationId];
}

class LoggedInState extends AuthState {
  final FirebaseUser user;

  LoggedInState(this.user) : super([user]);

  @override
  List<Object> get props => [user];
}

class UserNotRegisteredState extends AuthState {
  final FirebaseUser user;

  UserNotRegisteredState(this.user) : super([user]);

  @override
  List<Object> get props => [user];
}

class LoginFailed extends AuthState {
  final String error;

  LoginFailed(this.error) : super([error]);

  @override
  List<Object> get props => [error];
}

class LoggedOutState extends AuthState {
  LoggedOutState() : super([]);

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  AuthLoading() : super([]);
  @override
  List<Object> get props => [];
}
