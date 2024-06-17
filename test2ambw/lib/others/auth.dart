import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/customer/login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is loggen in
          if(snapshot.hasData){
            return HomeCustomer();
          }else{
            return LoginPage();
          }
        },
      ),
    );
  }
}