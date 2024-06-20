import 'package:flutter/material.dart';

class AdminPortal extends StatelessWidget {
  const AdminPortal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Lexend'),
      home: Scaffold(
        body: Center(
          child: Text('WOI ADMIN!'),
        ),
      ),
    );
  }
}