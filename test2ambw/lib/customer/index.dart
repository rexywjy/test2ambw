import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class HomeCustomer extends StatelessWidget {
  HomeCustomer({super.key});

  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('YOLO'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: signUserOut,
          ),],
      ),
      body: Center(child: Text("Welcome back, " + user!.email!),),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(fontFamily: 'Lexend'),
    //   home: LoginPage(),
    // );
  }
}