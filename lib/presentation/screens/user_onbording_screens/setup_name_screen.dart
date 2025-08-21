import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/validate.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class SetupNameScreen extends StatefulWidget {
  const SetupNameScreen({super.key});

  @override
  State<SetupNameScreen> createState() => _SetupNameScreenState();
}

class _SetupNameScreenState extends State<SetupNameScreen> {
  late TextEditingController nameController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  Validate validate = Validate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const AppSpacingLarge(),
              HeadlineMedium(text: "Create your name"),
              const AppSpacingSmall(),
              BodyMedium(text: "Get more people to know your name"),
              const AppSpacingMedium(),
              AppTextField(
                  hint: "Name",
                  leadingIcon: const Icon(FeatherIcons.user),
                  validate: (value) {
                    return validate.isNameValidd(value);
                  },
                  control: nameController,
                  keybordType: TextInputType.name),
              Expanded(child: Container()),
              AppExtendedElevatedButton(
                  buttonLable: "Continue",
                  buttonClick: () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<ProfileHandlerViewModel>(context,
                              listen: false)
                          .setUserName(nameController.text.toString().trim());
                      context.router.push(AddYourPhoto());
                    }
                  })
            ],
          )),
    );
  }
}
