import 'package:flutter/material.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/customer/register.dart';

class LoginCheckSellerPage extends StatefulWidget {
  const LoginCheckSellerPage({super.key});

  @override
  State<LoginCheckSellerPage> createState() => _LoginCheckSellerPageState();
}

class _LoginCheckSellerPageState extends State<LoginCheckSellerPage> {
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