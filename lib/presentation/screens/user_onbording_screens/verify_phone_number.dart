// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/validate.dart';
import 'package:samvaad/data/repositories_impl/phone_number_auth.dart';
import 'package:samvaad/domain/use_case/auth_phone_number.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/viewmodels/phone_auth_view_model.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class VerifyPhoneNumber extends StatefulWidget {
  final bool isChangeNumber;
  const VerifyPhoneNumber({super.key, this.isChangeNumber = false});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController regionController;
  late TextEditingController phoneNumberController;
  Validate validate = Validate();

  @override
  void initState() {
    super.initState();
    regionController = TextEditingController();
    phoneNumberController = TextEditingController();
    regionController.text = "(+91) India";
  }

  @override
  void dispose() {
    super.dispose();
    regionController.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PhoneAuthViewModel>(builder: (context, auth, child) {
        return Form(
            key: formKey,
            child: Column(
              children: [
                AppSpacingLarge(),
                HeadlineMedium(text: "Enter your phone number"),
                AppSpacingSmall(),
                BodyMedium(text: "Please confirm your region and enter"),
                AppSpacingTiny(),
                BodyMedium(text: "your phone number"),
                AppSpacingMedium(),
                AppTextField(
                  hint: "Your region",
                  leadingIcon: Icon(
                    FeatherIcons.globe,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validate: (value) {},
                  control: regionController,
                  keybordType: TextInputType.none,
                  isReadOnly: true,
                ),
                SizedBox(
                  height: 25,
                ),
                AppTextField(
                  hint: "Phone number",
                  leadingIcon: Icon(
                    FeatherIcons.phone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validate: (value) {
                    return validate.validatePhoneNumber(value!);
                  },
                  control: phoneNumberController,
                  keybordType: TextInputType.phone,
                  textMaxLenght: 10,
                ),
                Expanded(child: Container()),
                AppExtendedElevatedButton(
                    buttonLable: "Continue",
                    buttonClick: () async {
                      log("continue pressed");
                      if (formKey.currentState!.validate()) {
                        String phoneNumber =
                            "+91${phoneNumberController.text.trim()}";
                        if (widget.isChangeNumber) {
                          if (CurrentUser.instance.currentUser!.phoneNo ==
                              phoneNumber) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Your already logged in")));
                            return;
                          }
                          bool goToUpdate = true;
                          log("phone number");
                          final result =
                              await Provider.of<UserDetailsViewModel>(context,
                                      listen: false)
                                  .searchUser(phoneNumber);

                          if (result != null) {
                            log("showing warning dialog");
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Warning"),
                                    content: Text(
                                      "There is already account exit with this number if you continue you will loos data of that other account",
                                      softWrap: true,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            goToUpdate = false;
                                            getIt<AppRouter>().maybePop();
                                          },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            getIt<AppRouter>().maybePop();
                                          },
                                          child: Text("Continue")),
                                    ],
                                  );
                                });
                          }

                          if (goToUpdate) {
                            log("going to update screen");
                            final provider = Provider.of<PhoneAuthViewModel>(
                                context,
                                listen: false);
                            provider.requestAuthentication(phoneNumber);
                            getIt<AppRouter>().push(
                                VerificationCodeWrapperRoute(
                                    isChangeNumber: true,
                                    phoneNumber: phoneNumber,
                                    phoneAuthViewModel: provider));
                          }
                        } else {
                          auth.requestAuthentication(phoneNumber);

                          context.router.push(VerificationCodeRoute(
                              phoneNumber: phoneNumber,
                              isChangeNumber: widget.isChangeNumber));
                        }
                        log("nothing happend");
                      }
                    })
              ],
            ));
      }),
    );
  }
}
