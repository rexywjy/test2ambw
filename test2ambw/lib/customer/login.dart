import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test2ambw/components/squaretile.dart';
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
  void signInUser() async {
    // print('Username: ${usernameController.text}');
    // print('Password: ${passwordController.text}');
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: usernameController.text,
      password: passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      // backgroundColor: mainBlue,
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView (
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // logo
                const SizedBox(height: 50,),
                Icon(
                  Icons.airplane_ticket_rounded, 
                  size: 100, 
                  color: mainBlue2,
                  ),
                const SizedBox(height: 50,),
        
                // welcome back
                Text(
                  'Welcome Back, Traveler!', 
                  style: TextStyle(
                    fontSize: 20, 
                    color: Colors.grey[600])),
                const SizedBox(height: 20,),
        
                // email
                LoginTextField(
                  controller: usernameController, 
                  hintText: 'Email', 
                  obscureText: false, 
                  iconInput: Icon(Icons.email)
                  ),
                const SizedBox(height: 10,),
        
                // password
                LoginTextField(
                  controller: passwordController, 
                  hintText: 'Password', 
                  obscureText: true, 
                  iconInput: Icon(Icons.lock) 
                  ),
                const SizedBox(height: 10,),
        
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
                const SizedBox(height: 20,),
        
                // sign in button
                LoginButton(
                  onTap: signInUser,
                ),
                const SizedBox(height: 20,),
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        )
                      ),
                      Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                // google sign in buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/images/googlelogo1.png'),
                    SizedBox(width: 30,),
                    SquareTile(imagePath: 'assets/images/applelogo1.png'),
                  ],
                ),
                const SizedBox(height: 20,),
        
                // register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't have an account? "),
                    SizedBox(width: 5,),
                    Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}