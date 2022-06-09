import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  bool isSecure;
  TextFieldInput(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.inputType,
      this.isSecure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      obscureText: isSecure,
      keyboardType: inputType,
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        hintText: hintText,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
