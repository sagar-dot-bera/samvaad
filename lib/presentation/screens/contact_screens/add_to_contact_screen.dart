import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';

@RoutePage()
class AddToContactScreen extends StatefulWidget {
  const AddToContactScreen({super.key});

  @override
  State<AddToContactScreen> createState() => _AddToContactScreenState();
}

class _AddToContactScreenState extends State<AddToContactScreen> {
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactLastNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final formeKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    countryCodeController.text = "+91 (India)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Add Contact"),
        actions: [
          IconButton(
              onPressed: () {
                //add contact
              },
              icon: Icon(Remix.check_line))
        ],
      ),
      body: Form(
        key: formeKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
                hint: "First name",
                leadingIcon: Icon(Remix.user_line),
                validate: (value) {},
                control: contactLastNameController,
                keybordType: TextInputType.text),
            AppSpacingSmall(),
            AppSpacingSmall(),
            AppTextField(
                hint: "Last Name",
                leadingIcon: Icon(Remix.user_line),
                validate: (value) {},
                control: contactNameController,
                keybordType: TextInputType.text),
            AppSpacingSmall(),
            AppSpacingSmall(),
            AppTextField(
                hint: "Your region",
                leadingIcon: Icon(Remix.global_line),
                validate: (value) {},
                control: countryCodeController,
                keybordType: TextInputType.text,
                isReadOnly: true),
            AppSpacingSmall(),
            AppSpacingSmall(),
            AppTextField(
                hint: "Phone number",
                leadingIcon: Icon(Remix.phone_line),
                validate: (value) {},
                control: phoneNumberController,
                keybordType: TextInputType.number)
          ],
        ),
      ),
    );
  }
}
