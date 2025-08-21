import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/data/repositories_impl/phone_number_auth.dart';
import 'package:samvaad/domain/use_case/auth_phone_number.dart';
import 'package:samvaad/presentation/viewmodels/phone_auth_view_model.dart';

@RoutePage()
class StartOnbordingScreen extends StatelessWidget {
  const StartOnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhoneAuthViewModel(
            authenticatePhoneNumber: AuthenticatePhoneNumber(
                authenticatePhoneRepositories:
                    FirebaseAuthRepository(auth: FirebaseAuth.instance))),
        child: Scaffold(
          body: AutoRouter(),
        ));
  }
}
