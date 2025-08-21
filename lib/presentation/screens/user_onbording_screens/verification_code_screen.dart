// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/validate.dart';
import 'package:samvaad/main.dart';

import 'package:samvaad/presentation/viewmodels/phone_auth_view_model.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_code_verification_text_field.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class VerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isChangeNumber;
  const VerificationCodeScreen(
      {super.key, required this.phoneNumber, this.isChangeNumber = false});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  late TextEditingController firstDigitCodeTextController;
  late TextEditingController secondDigitCodeTextController;
  late TextEditingController thiredDigitCodeTextController;
  late TextEditingController fourthDigitCodeTextController;
  late TextEditingController fifthDigitCodeTextController;
  late TextEditingController sixthDigitcodeTextController;

  late FocusNode firstDigitCodeTextFocusNode;
  late FocusNode secondDigitCodeTextFocusNode;
  late FocusNode thiredDigitCodeTextFocusNode;
  late FocusNode fourthDigitCodeTextFocusNode;
  late FocusNode fifthDigitCodeTextFocusNode;
  late FocusNode sixthDigitCodeTextFocusNode;

  ValueNotifier<int> verificationCodeTimerMinutes = ValueNotifier(2);
  ValueNotifier<int> verificationCodeTimerSeconds = ValueNotifier(0);
  Timer? _timer;
  bool isResentCodeOn = false;

  void verificationCodeCountDown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (verificationCodeTimerSeconds.value == 0 &&
          verificationCodeTimerMinutes.value > 0) {
        verificationCodeTimerSeconds.value = 60;
        verificationCodeTimerMinutes.value =
            verificationCodeTimerMinutes.value - 1;
      } else if (verificationCodeTimerMinutes.value == 0 &&
          verificationCodeTimerSeconds.value == 0) {
        _timer?.cancel();
        setState(() {
          isResentCodeOn = true;
        });
      } else if (verificationCodeTimerSeconds.value != 0) {
        verificationCodeTimerSeconds.value =
            verificationCodeTimerSeconds.value - 1;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    firstDigitCodeTextController = TextEditingController();
    secondDigitCodeTextController = TextEditingController();
    thiredDigitCodeTextController = TextEditingController();
    fourthDigitCodeTextController = TextEditingController();
    fifthDigitCodeTextController = TextEditingController();
    sixthDigitcodeTextController = TextEditingController();

    firstDigitCodeTextFocusNode = FocusNode();
    secondDigitCodeTextFocusNode = FocusNode();
    thiredDigitCodeTextFocusNode = FocusNode();
    fourthDigitCodeTextFocusNode = FocusNode();
    fifthDigitCodeTextFocusNode = FocusNode();
    sixthDigitCodeTextFocusNode = FocusNode();
    verificationCodeCountDown();
  }

  @override
  void dispose() {
    super.dispose();
    firstDigitCodeTextController.dispose();
    secondDigitCodeTextController.dispose();
    thiredDigitCodeTextController.dispose();
    fourthDigitCodeTextController.dispose();
    fifthDigitCodeTextController.dispose();
    sixthDigitCodeTextFocusNode.dispose();

    firstDigitCodeTextFocusNode.dispose();
    secondDigitCodeTextFocusNode.dispose();
    thiredDigitCodeTextFocusNode.dispose();
    fourthDigitCodeTextFocusNode.dispose();
    fifthDigitCodeTextFocusNode.dispose();
    sixthDigitCodeTextFocusNode.dispose();
    _timer?.cancel();
  }

  void changeFouseToNextFiled(
    String? currentFieldText,
    FocusNode nextFieldFocusNode,
    TextEditingController nextFieldTextController, [
    FocusNode? previousFieldFocusNode,
    TextEditingController? previousFieldTextController,
  ]) {
    if (currentFieldText!.isNotEmpty && nextFieldTextController.text.isEmpty) {
      nextFieldFocusNode.requestFocus();
    } else if (previousFieldFocusNode != null &&
        previousFieldTextController != null &&
        currentFieldText.isEmpty) {
      previousFieldFocusNode.requestFocus();
    }
  }

  final formKey = GlobalKey<FormState>();
  Validate validate = Validate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //for spacing
              AppSpacingLarge(),
              HeadlineMedium(text: "Enter Code"),
              //for spacing
              AppSpacingSmall(),
              BodyMedium(text: "Enter code sent via sms to "),
              //for spacing
              AppSpacingTiny(),
              BodyMedium(text: ""),
              //for spacing
              AppSpacingMedium(),
              //verification code text fields
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppCodeVerificationTextField(
                        validate: (value) {
                          return validate.checkIfFieldIsNull(value);
                        },
                        onChanged: (text) {
                          changeFouseToNextFiled(
                              text,
                              secondDigitCodeTextFocusNode,
                              secondDigitCodeTextController);
                        },
                        control: firstDigitCodeTextController,
                        keybordType: TextInputType.number,
                        focusNode: firstDigitCodeTextFocusNode),
                    AppCodeVerificationTextField(
                        validate: (value) {
                          return validate.checkIfFieldIsNull(value);
                        },
                        onChanged: (text) {
                          changeFouseToNextFiled(
                              text,
                              thiredDigitCodeTextFocusNode,
                              thiredDigitCodeTextController,
                              firstDigitCodeTextFocusNode,
                              firstDigitCodeTextController);
                        },
                        control: secondDigitCodeTextController,
                        keybordType: TextInputType.number,
                        focusNode: secondDigitCodeTextFocusNode),
                    AppCodeVerificationTextField(
                        validate: (value) {
                          return validate.checkIfFieldIsNull(value);
                        },
                        onChanged: (text) {
                          changeFouseToNextFiled(
                              text,
                              fourthDigitCodeTextFocusNode,
                              fourthDigitCodeTextController,
                              secondDigitCodeTextFocusNode,
                              secondDigitCodeTextController);
                        },
                        control: thiredDigitCodeTextController,
                        keybordType: TextInputType.number,
                        focusNode: thiredDigitCodeTextFocusNode),
                    AppCodeVerificationTextField(
                        validate: (value) {
                          return validate.checkIfFieldIsNull(value);
                        },
                        onChanged: (text) {
                          changeFouseToNextFiled(
                              text,
                              fifthDigitCodeTextFocusNode,
                              fifthDigitCodeTextController,
                              fourthDigitCodeTextFocusNode,
                              fourthDigitCodeTextController);
                        },
                        control: fourthDigitCodeTextController,
                        keybordType: TextInputType.number,
                        focusNode: fourthDigitCodeTextFocusNode),
                    AppCodeVerificationTextField(
                        validate: (value) {
                          return validate.checkIfFieldIsNull(value);
                        },
                        onChanged: (text) {
                          changeFouseToNextFiled(
                              text,
                              sixthDigitCodeTextFocusNode,
                              sixthDigitcodeTextController,
                              fifthDigitCodeTextFocusNode,
                              fifthDigitCodeTextController);
                        },
                        control: fifthDigitCodeTextController,
                        keybordType: TextInputType.number,
                        focusNode: fifthDigitCodeTextFocusNode),
                    AppCodeVerificationTextField(
                        validate: (value) {
                          return validate.checkIfFieldIsNull(value);
                        },
                        onChanged: (p0) {},
                        control: sixthDigitcodeTextController,
                        keybordType: TextInputType.number,
                        focusNode: sixthDigitCodeTextFocusNode),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                      valueListenable: verificationCodeTimerMinutes,
                      builder: (context, value, child) {
                        return Text("0$value:");
                      }),
                  ValueListenableBuilder(
                    valueListenable: verificationCodeTimerSeconds,
                    builder: (context, value, child) {
                      if (value < 10) {
                        return Text("0$value");
                      } else {
                        return Text("$value");
                      }
                    },
                  )
                ],
              ),
              Expanded(child: Container()),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BodyMedium(text: "Did't get the code?"),
                      GestureDetector(
                          onTap: () {
                            if (isResentCodeOn) {
                              verificationCodeTimerMinutes.value = 2;
                              verificationCodeTimerSeconds.value = 0;
                              verificationCodeCountDown();
                              final phoneAuthProvider =
                                  Provider.of<PhoneAuthViewModel>(context,
                                      listen: false);
                              phoneAuthProvider
                                  .requestAuthentication(widget.phoneNumber);
                            }
                          },
                          child: !isResentCodeOn
                              ? Text(" Resend Code",
                                  style: TextStyle(
                                      color: AppColors.neutralDarkGray,
                                      fontSize: 18))
                              : Text(" Resend Code",
                                  style: TextStyle(
                                      color: AppColors.accentGreen,
                                      fontSize: 18)))
                    ],
                  ),
                ),
              ),

              AppExtendedElevatedButton(
                  buttonLable: "Verify",
                  buttonClick: () async {
                    if (formKey.currentState!.validate()) {
                      String code = firstDigitCodeTextController.text +
                          secondDigitCodeTextController.text +
                          thiredDigitCodeTextController.text +
                          fourthDigitCodeTextController.text +
                          fifthDigitCodeTextController.text +
                          sixthDigitcodeTextController.text;

                      final phoneAuthProvider = Provider.of<PhoneAuthViewModel>(
                          context,
                          listen: false);

                      if (phoneAuthProvider.verficationReferenceId.isNotEmpty) {
                        await phoneAuthProvider.requestCodeVerification(
                            phoneAuthProvider.verficationReferenceId, code);

                        if (phoneAuthProvider.verificationStatus) {
                          if (widget.isChangeNumber) {
                            getIt<AppRouter>()
                                .push(UpdatingNumberAndDataRoute());
                          } else {
                            getIt<AppRouter>().push(CreateProfileRoute());
                          }
                        } else {}
                      }
                    }
                  })
            ],
          )),
    );
  }
}
