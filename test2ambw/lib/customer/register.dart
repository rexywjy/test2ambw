import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test2ambw/components/errordialog.dart';
import 'package:test2ambw/components/squaretile.dart';
import '../components/loginbutton.dart';
import '../components/loginTextField.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);

  final Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);

  final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

  final Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);

  // sign in user button method
  void signUpUser() async {
    if(usernameController.text.isEmpty || passwordController.text.isEmpty || confirmpasswordController.text.isEmpty){
      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(errormsg: "Please fill in all fields");
        },
      );
      return;
    }
    // Show the loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainBlue),
          ),
        );
      },
    );

    try {
      if(confirmpasswordController.text != passwordController.text){
        // Dismiss the loading circle
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(errormsg: "Passwords doesn't match");
          },
        );
        return;
      }

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      // If successful, pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Handle the error, show a message, etc.
      print('Error: $e');
      // Dismiss the loading circle
      Navigator.pop(context);
      // Optionally, show an error dialog or a message to the user
      print("Error code: " + e.code);
      if((e.code != 'user-not-found' && e.code != 'wrong-password' && e.code != 'invalid-credential')){
        showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(errormsg: e.message ?? 'An error occurred');
          },
        );
      }else{
        showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(errormsg: "Invalid email or password");
          },
        );
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      // backgroundColor: mainBlue,
      // backgroundColor: Colors.grey[200],
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
                
                // confirm password
                LoginTextField(
                  controller: confirmpasswordController, 
                  hintText: 'Confirm Password', 
                  obscureText: true, 
                  iconInput: Icon(Icons.lock) 
                  ),
                const SizedBox(height: 40,),

                // sign in button
                LoginButton(
                  onTap: signUpUser,
                  buttontext: 'Sign Up',
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
                    Text("Have an account? "),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold
                        ),
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