import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

//abstract class for auth repositorie
abstract class AuthenticatePhoneRepositories {
  //method to authenticate phone number
  Future<void> authenticatePhoneNumber(
      String phoneNumber, OtpCodeSentCallback otpCodeSentCallback);
  Future<bool> authenticateOtp(String verificationId, String otpCode);
}

typedef OtpCodeSentCallback = void Function(
    String verificationId, int resendTokenId);
