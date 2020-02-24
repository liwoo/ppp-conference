import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ppp_conference/repositories/auth_repository.dart';
import 'package:ppp_conference/repositories/user_repository.dart';
import 'package:ppp_conference/services/phone_login.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  IAuthRepository authRepository;
  IUserRepository userRepository = UserRepository(Firestore.instance);
  AuthBloc({@required this.authRepository});

  @override
  AuthState get initialState => LoadingAuthState();

  AuthState get currentState => this.state;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is InitializeAuth) {
      try {
        FirebaseUser user = await authRepository.getUser();
        if (user == null) {
          yield LoggedOutState();
        } else {
          yield LoggedInState(user);
        }
      } catch (e) {
        print(e);
        yield LoggedOutState();
      }
    }
    if (event is GoogleLogin) {
      FirebaseUser user =
          await authRepository.socialLogin(SocialLoginMethod.google);
      if (user == null) {
        yield LoggedOutState();
      } else {
        bool isRegistered = await userRepository.isRegistered(user);
        if (isRegistered)
          yield LoggedInState(user);
        else {
          await authRepository.logout();
          yield UserNotRegisteredState(user);
        }
      }
    }
    if (event is PhoneLogin) {
      PhoneLoginService phoneLoginService = PhoneLoginService(event.context);
      phoneLoginService.initiatePhoneLogin(event.phoneNumber);
      yield AuthLoading();
    }
    if (event is MobilePinSent) {
      if (state is AuthLoading)
        yield MobilePinSentState(event.verificationId);
      else
        print('being cheeky');
    }
    if (event is SubmitPin) {
      MobilePinSentState prevState = state;
      print(prevState.verificationId);
      String error;
      yield AuthLoading();

      FirebaseUser user = await authRepository
          .mobileLogin(prevState.verificationId, event.pin)
          .catchError((err) {
        error = err;
      });
      if (user != null) {
        bool isRegistered = await userRepository.isRegistered(user);
        if (isRegistered)
          yield LoggedInState(user);
        else {
          await authRepository.logout();
          yield UserNotRegisteredState(user);
        }
      } else {
        yield LoginFailed(error);
      }
    }
    if (event is LoginSuccess) {
      bool isRegistered = await userRepository.isRegistered(event.user);
      if (isRegistered)
        yield LoggedInState(event.user);
      else {
        await authRepository.logout();
        yield UserNotRegisteredState(event.user);
      }
    }
    if (event is Logout) {
      await authRepository.logout();
      yield LoggedOutState();
    }
    if (event is LoginFailure) {
      await authRepository.logout();
      yield LoginFailed(event.error);
    }
  }
}
