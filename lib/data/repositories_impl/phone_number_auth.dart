import 'package:firebase_auth/firebase_auth.dart';
import 'package:samvaad/domain/repositories/auth_phone_number_repo.dart';

class FirebaseAuthRepository extends AuthenticatePhoneRepositories {
  FirebaseAuth auth;

  FirebaseAuthRepository({required this.auth});

  @override
  Future<void> authenticatePhoneNumber(
      String phoneNumber, OtpCodeSentCallback otpCodeSentCallback) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException exception) {},
        codeSent: (String referenceId, int? resendToken) {
          otpCodeSentCallback(referenceId, resendToken!);
        },
        codeAutoRetrievalTimeout: (String timeOut) {});
  }

  @override
  Future<bool> authenticateOtp(String verificationId, String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);

    var authResult = await auth.signInWithCredential(credential);

    if (authResult.user != null) {
      return true;
    } else {
      return false;
    }
  }
}
