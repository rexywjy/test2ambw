import 'package:flutter/material.dart';
import 'customer/index.dart';
import 'admin/index.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
  final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Lexend'),
      home: HomeCustomer(),
      // home: Scaffold(
      //   body: Center(
      //     child: Text('Hello World!'),
      //   ),
      // ),
    );
  }
}
