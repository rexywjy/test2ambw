import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final errormsg;

  const ErrorDialog({
    super.key,
    required this.errormsg,
    });

  @override
  Widget build(BuildContext context) {
    final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
    final Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);
    final Color mainYellow = Color.fromARGB(255, 253, 222, 85);
    final Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);
    final TextAlign? textAlign;
    
    return AlertDialog(
      title: const Icon(
        Icons.error,
        color: Colors.red,
        size: 50,
      ),
      content: Center(
        heightFactor: 1.5,
        child: Text(
          textAlign: TextAlign.center,
          errormsg,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Lexend',
          ),
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ),
      ],
    );
  }
}