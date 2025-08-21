import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samvaad/core/themes/app_colors.dart';

class AppCodeVerificationTextField extends StatelessWidget {
  String? Function(String?)? validate;
  TextEditingController control;
  TextInputType keybordType;
  int? textMaxLenght;
  int? textMaxLine;
  FocusNode focusNode;
  void Function(String?) onChanged;

  AppCodeVerificationTextField(
      {required this.validate,
      required this.control,
      required this.onChanged,
      required this.keybordType,
      required this.focusNode,
      this.textMaxLenght = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: Container(
        width: 45,
        height: 90,
        child: TextFormField(
          onChanged: onChanged,
          focusNode: focusNode,
          style:
              TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          textAlign: TextAlign.center,
          controller: control,
          maxLines: textMaxLine,
          keyboardType: keybordType,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              hintStyle: Theme.of(context).textTheme.bodySmall,
              focusColor: Theme.of(context).colorScheme.primary,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: AppColors.neutralGray))),
          validator: validate,
        ),
      ),
    );
  }
}
