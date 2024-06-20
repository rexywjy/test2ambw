import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/customer/loginorregister.dart';
import 'package:test2ambw/seller/index.dart';

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
            return HomeSeller();
          }else{
            // return LoginPage();
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}