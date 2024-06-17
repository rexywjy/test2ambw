import 'package:firebase_core/firebase_core.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/others/auth.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'customer/index.dart';
import 'admin/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // home: HomeCustomer(),
      home: const AuthPage(),
      // home: Scaffold(
      //   body: Center(
      //     child: Text('Hello World!'),
      //   ),
      // ),
    );
  }
}
