import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/repositories_impl/phone_number_auth.dart';
import 'package:samvaad/domain/use_case/auth_phone_number.dart';
import 'package:samvaad/presentation/screens/user_onbording_screens/verification_code_screen.dart';
import 'package:samvaad/presentation/viewmodels/phone_auth_view_model.dart';

@RoutePage()
class VerificationCodeWrapperScreen extends StatelessWidget
    implements AutoRouteWrapper {
  final String phoneNumber;
  final bool isChangeNumber;
  final PhoneAuthViewModel phoneAuthViewModel;
  const VerificationCodeWrapperScreen(
      {super.key,
      required this.phoneNumber,
      this.isChangeNumber = false,
      required this.phoneAuthViewModel});

  @override
  Widget build(BuildContext context) {
    return VerificationCodeScreen(
      phoneNumber: phoneNumber,
      isChangeNumber: true,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: phoneAuthViewModel,
      child: this,
    );
  }
}
