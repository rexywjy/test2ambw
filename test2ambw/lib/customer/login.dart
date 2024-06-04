import 'package:flutter/material.dart';
import '../components/loginTextField.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // logo
              SizedBox(height: 50,),
              Icon(
                Icons.airplane_ticket_rounded, 
                size: 100, 
                color: Colors.grey[600]
                ),
              SizedBox(height: 50,),

              // welcome back
              Text(
                'Welcome Back, Traveler!', 
                style: TextStyle(
                  fontSize: 20, 
                  color: Colors.grey[600])),
              SizedBox(height: 20,),

              // email
              LoginTextField(
                controller: usernameController, 
                hintText: 'Email', 
                obscureText: false, 
                iconInput: Icon(Icons.email)
                ),
              SizedBox(height: 10,),

              // password
              LoginTextField(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true, 
                iconInput: Icon(Icons.lock)
                ),
              SizedBox(height: 10,),

              // forgot password?
              Text('Forgot Password?', style: TextStyle(color: Colors.grey[600])),
              // sign in button
              // or continue with
              // google sign in buttons
              // register button
            ],
          ),
        ),
      ),
    );
  }
}