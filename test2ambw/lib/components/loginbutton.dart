import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: mainBlue,
      ),
      // width: 200,
      // height: 50,
      child: Center(
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}