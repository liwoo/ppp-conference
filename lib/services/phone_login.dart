import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppp_conference/bloc/auth/bloc.dart';
import 'package:ppp_conference/repositories/auth_repository.dart';

class PhoneLoginService {
  AuthRepository authRepository = AuthRepository(FirebaseAuth.instance);
  BuildContext context;
  PhoneLoginService(this.context);
  initiatePhoneLogin(phoneNumber) {
    final _authBloc = BlocProvider.of<AuthBloc>(context);

    Stream<MobileLogin> mobileLogin =
        authRepository.requestMobileLoginPin(phoneNumber);
    mobileLogin.listen((data) {
      switch (data.state) {
        case MobileLoginState.codeSent:
          _authBloc.add(MobilePinSent(data.verificationId));
          break;
        case MobileLoginState.autoRetrieved:
          _authBloc.add(MobilePinSent(data.verificationId));
          break;
        case MobileLoginState.complete:
          _authBloc.add(LoginSuccess(data.user));
          break;
        default:
          _authBloc.add(LoginFailure(data.error));
      }
    });
  }
}
