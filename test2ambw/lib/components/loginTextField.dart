import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Icon iconInput;
  final String type;

  static const Color mainBlue = Color.fromARGB(255, 3, 174, 210);
  static const Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);
  static const Color mainLightGrey = Color.fromARGB(255, 209, 209, 209);
  static const Color mainYellow = Color.fromARGB(255, 253, 222, 85);
  static const Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconInput,
    required this.type
    });

  // constructor
  // LoginTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(type == "nospace"){
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
              borderSide: BorderSide(color: mainBlue2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(r'\s')),
          ],
        ),
      );
    }
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
            borderSide: BorderSide(color: mainBlue2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}