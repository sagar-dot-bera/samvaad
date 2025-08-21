import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/size.dart';

class AppTextField extends StatelessWidget {
  String hint;
  Widget leadingIcon;
  String? Function(String?)? validate;
  TextEditingController control;
  TextInputType keybordType;
  int? textMaxLenght;
  int? textMaxLine;
  bool? isReadOnly;
  double? optionalPadding;
  Widget? sufficIcon;
  Function(String?)? onTextChange;

  AppTextField(
      {super.key,
      required this.hint,
      required this.leadingIcon,
      required this.validate,
      required this.control,
      required this.keybordType,
      this.textMaxLenght,
      this.isReadOnly = false,
      this.textMaxLine = 1,
      this.sufficIcon,
      this.optionalPadding = 0.0,
      this.onTextChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: optionalPadding == 0.0 ? 30 : optionalPadding!),
      child: TextFormField(
        style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
        controller: control,
        readOnly: isReadOnly!,
        maxLength: textMaxLenght,
        maxLines: textMaxLine,
        keyboardType: keybordType,
        onChanged: onTextChange,
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus();
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            focusColor: Theme.of(context).colorScheme.primary,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: AppColors.neutralGray)),
            prefixIcon: leadingIcon,
            suffixIcon: sufficIcon),
        validator: validate,
      ),
    );
  }
}
