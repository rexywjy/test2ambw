import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;

  const LoginButton({
    super.key,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
  final Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);
    final Color mainYellow = Color.fromARGB(255, 253, 222, 85);
    final Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: mainBlue2,
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
      ),
    );
  }
}