import 'package:flutter/material.dart';

class HomeSeller extends StatelessWidget {
  const HomeSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Lexend'),
      home: Scaffold(
        body: Center(
          child: Text('WOI SELLER!'),
        ),
      ),
    );
  }
}