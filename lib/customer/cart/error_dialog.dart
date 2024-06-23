import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WarningErrorDialog extends StatefulWidget {
  final String msg;
  final String msg_detail;
  const WarningErrorDialog({Key? key, required this.msg, required this.msg_detail}) : super(key: key);

  @override
  _WarningDialogState createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningErrorDialog> {
  @override
  void initState() {
    super.initState();
    // Start a timer to automatically close the dialog after 1 second
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.2),
              ),
              child: Icon(
                Icons.error_rounded,
                size: 80,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              widget.msg,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.msg_detail,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
