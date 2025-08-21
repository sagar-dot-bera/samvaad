import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/repositories_impl/phone_number_auth.dart';
import 'package:samvaad/domain/use_case/auth_phone_number.dart';
import 'package:samvaad/presentation/screens/user_onbording_screens/verify_phone_number.dart';
import 'package:samvaad/presentation/viewmodels/phone_auth_view_model.dart';

@RoutePage()
class VerificationScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  final bool isChangeNumber;
  const VerificationScreenWrapper({super.key, required this.isChangeNumber});

  @override
  Widget build(BuildContext context) {
    return VerifyPhoneNumber(
      isChangeNumber: isChangeNumber,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhoneAuthViewModel(
          authenticatePhoneNumber: AuthenticatePhoneNumber(
              authenticatePhoneRepositories:
                  FirebaseAuthRepository(auth: FirebaseAuth.instance))),
      child: this,
    );
  }
}
