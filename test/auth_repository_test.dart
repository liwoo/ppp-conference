import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:ppp_conference/repositories/auth_repository.dart';
import 'package:test/test.dart';

main() {
  final firebaseAuth = MockFirebaseAuth();
  final googleSignIn = MockGoogleSignIn();
  final authRepository =
      AuthRepository(firebaseAuth, googleSignIn: googleSignIn);

  test('google socialLogin should return a firebase user', () async {
    final FirebaseUser user =
        await authRepository.socialLogin(SocialLoginMethod.google);
    expect(user, isA<FirebaseUser>());
  });
  test('requestMobileLoginPin should return', () async {
    var phoneLoginStream = authRepository.requestMobileLoginPin("+16505551234");
    expect(phoneLoginStream, emits(MobileLogin));
  });
}
