import 'package:flutter/material.dart';
import 'customer/index.dart';
import 'admin/index.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeCustomer(),
      // home: Scaffold(
      //   body: Center(
      //     child: Text('Hello World!'),
      //   ),
      // ),
    );
  }
}
