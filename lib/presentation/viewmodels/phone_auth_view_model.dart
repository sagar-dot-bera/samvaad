import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/domain/use_case/auth_phone_number.dart';

class PhoneAuthViewModel extends ChangeNotifier {
  AuthenticatePhoneNumber authenticatePhoneNumber;
  String verficationReferenceId = '';
  bool? _verificationStatus;

  bool get verificationStatus => _verificationStatus!;
  PhoneAuthViewModel({required this.authenticatePhoneNumber});

  Future<void> requestAuthentication(String phoneNumber) async {
    await authenticatePhoneNumber.verifyPhoneNumber(phoneNumber,
        (String referenceId, int resendTokenId) {
      verficationReferenceId = referenceId;
    });
  }

  Future<void> requestCodeVerification(String referenceId, String code) async {
    bool verificationResult =
        await authenticatePhoneNumber.verifyOtp(referenceId, code);

    if (verificationResult) {
      _verificationStatus = true;
      notifyListeners();
    } else {
      _verificationStatus = false;
      notifyListeners();
    }
  }
}
