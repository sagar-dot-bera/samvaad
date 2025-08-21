import 'dart:ffi';

import 'package:samvaad/domain/repositories/auth_phone_number_repo.dart';

class AuthenticatePhoneNumber {
  AuthenticatePhoneRepositories authenticatePhoneRepositories;

  AuthenticatePhoneNumber({required this.authenticatePhoneRepositories});

  Future<void> verifyPhoneNumber(
      String phoneNumber, OtpCodeSentCallback otpCodeSentCallback) async {
    return await authenticatePhoneRepositories.authenticatePhoneNumber(
        phoneNumber, otpCodeSentCallback);
  }

  Future<bool> verifyOtp(String verficationId, String code) async {
    return await authenticatePhoneRepositories.authenticateOtp(
        verficationId, code);
  }
}
