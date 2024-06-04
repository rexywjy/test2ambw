import 'package:flutter/material.dart';
import '../components/loginbutton.dart';
import '../components/loginTextField.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
  final Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);
  final Color mainYellow = Color.fromARGB(255, 253, 222, 85);
  final Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);

  // sign in user button method
  void signInUser() {
    print('Username: ${usernameController.text}');
    print('Password: ${passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: mainBlue,
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
                color: mainBlue2,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?', 
                      style: TextStyle(color: Colors.grey[600]),
                      
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              // sign in button
              LoginButton(
                onTap: signInUser,
              ),
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