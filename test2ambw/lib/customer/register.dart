import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/components/errordialog.dart';
import 'package:test2ambw/components/squaretile.dart';
import 'login.dart';
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
  final usernamecontroller = TextEditingController();
  final namacontroller = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);

  final Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);

  final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

  final Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);

  // insert mcustomer
  Future insertData(username,name,email) async {
    try {
      final List<Map<String, dynamic>> data = await Supabase.instance.client
            .from('mcustomer')
            .insert({
          'Email': email,
          'Name': name,
          'Username': username,
          'CreatedDate' : DateTime.now().toIso8601String(),
          'Status': 0,
          'IsDel' : 0
        }).select();
      print("Data Inserted: $data");
    } catch (e) {
      //print statment for identify insert error in if any , it will print the error in console
      print("Error while inserting Data: $e ");
    }
  }


  // sign in user button method
  void signUpUser() async {
    final supabase = Supabase.instance.client;
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmpasswordController.text.isEmpty) {
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

    // try {
    //   await supabase.auth.signUp(
    //     password: passwordController.text.trim(), 
    //     email: emailController.text.trim(),
    //   );
    //   if (!mounted) return;
    //   Navigator.pop(context);
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(onTap: widget.onTap)));
    // } on AuthException catch (e) {
    //   debugPrint('AuthException: ${e.message}, Status Code: ${e.statusCode}');
    //   Navigator.pop(context);
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return ErrorDialog(errormsg: e.message ?? 'An error occurred');
    //     },
    //   );
    // } catch (e) {
    //   debugPrint('Unexpected error: $e');
    //   Navigator.pop(context);
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return ErrorDialog(errormsg: 'An unexpected error occurred');
    //     },
    //   );
    // }

    try {
      if(confirmpasswordController.text != passwordController.text){
        // Dismiss the loading circle
        if(mounted){
          Navigator.pop(context);
        }
        showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(errormsg: "Passwords doesn't match");
          },
        );
        return;
      }

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Insert data to mcustomer
      try{
        insertData(usernamecontroller.text,namacontroller.text,emailController.text);
        // If successful, pop the loading circle
        Navigator.pop(context);
        // if(mounted){
        // }
      } catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(errormsg: "Invalid email or password");
          },
        );
      }
      
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
      resizeToAvoidBottomInset: false,
      // backgroundColor: mainBlue,
      // backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // logo
                const SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.airplane_ticket_rounded,
                  size: 100,
                  color: mainBlue2,
                ),
                const SizedBox(
                  height: 50,
                ),

                // username
                LoginTextField(
                  controller: usernamecontroller,
                  hintText: 'Username',
                  obscureText: false,
                  iconInput: Icon(Icons.abc),
                  type: 'username',
                ),
                const SizedBox(
                  height: 10,
                ),
                // nama
                LoginTextField(
                  controller: namacontroller,
                  hintText: 'Name',
                  obscureText: false,
                  iconInput: Icon(Icons.person),
                  type: ''
                ),
                const SizedBox(
                  height: 10,
                ),
                // email
                LoginTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  iconInput: Icon(Icons.email),
                  type: ''
                ),
                const SizedBox(
                  height: 10,
                ),

                // password
                LoginTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    iconInput: Icon(Icons.lock),
                    type: ''
                  ),
                const SizedBox(
                  height: 10,
                ),

                // confirm password
                LoginTextField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    iconInput: Icon(Icons.lock),
                    type: ''
                  ),
                const SizedBox(
                  height: 40,
                ),

                // sign in button
                LoginButton(
                  onTap: signUpUser,
                  buttontext: 'Sign Up',
                ),
                const SizedBox(
                  height: 20,
                ),
                // or continue with
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[600],
                      )),
                      Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[600],
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // google sign in buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/images/googlelogo1.png'),
                    SizedBox(
                      width: 30,
                    ),
                    SquareTile(imagePath: 'assets/images/applelogo1.png'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                // register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account? "),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
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
