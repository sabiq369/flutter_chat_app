import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  CommonTextField(
      {Key? key,
      required this.hintText,
      required this.prefixIcon,
      required this.controller})
      : super(key: key);
  String hintText;
  Widget prefixIcon;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffeaeef6),
        hintText: hintText,
        prefixIcon: prefixIcon,
        enabledBorder: borDec(),
        disabledBorder: borDec(),
        focusedBorder: borDec(),
      ),
    );
  }

  borDec() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.transparent),
    );
  }
}
