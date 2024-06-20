import 'package:flutter/material.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/customer/register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showlogin = true;

  void toggleView() {
    setState(() {
      showlogin = !showlogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showlogin){
      return LoginPage(onTap: toggleView);
    }else{
      return RegisterPage(onTap: toggleView);
    }
  }
}