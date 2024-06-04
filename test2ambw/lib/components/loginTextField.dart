import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Icon iconInput;

  static const Color mainBlue = Color.fromARGB(255, 3, 174, 210);
  static const Color mainLightGrey = Color.fromARGB(255, 209, 209, 209);

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconInput,
    });

  // constructor
  // LoginTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: iconInput,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainLightGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainBlue),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}