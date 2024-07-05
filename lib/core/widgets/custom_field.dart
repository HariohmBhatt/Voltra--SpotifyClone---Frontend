import 'package:flutter/material.dart';

// custom Textform field for all the auth pages and sign up pages

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.hinttext,
    required this.controller,
    this.makeObscureText = false,
    this.isreadOnly = false,
    this.onTap,
  });
  final String hinttext;
  final TextEditingController? controller;
  final bool makeObscureText;
  final bool isreadOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 395,
      child: TextFormField(
        onTap: onTap,
        readOnly: isreadOnly,
        controller: controller,
        decoration: InputDecoration(
          hintText: hinttext,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$hinttext is missing';
          }
          return null;
        },
        obscureText: makeObscureText,
      ),
    );
  }
}
