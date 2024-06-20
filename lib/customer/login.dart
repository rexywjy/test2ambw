import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/components/errordialog.dart';
import 'package:test2ambw/components/squaretile.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/seller/index.dart';
import '../components/loginbutton.dart';
import '../components/loginTextField.dart';
import 'package:supabase/supabase.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);

  final Color mainBlue2 = Color.fromARGB(255, 71, 147, 175);

  final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

  final Color mainPastelYellow = Color.fromARGB(255, 254, 239, 173);

  // supabase client
  final _supabaseClient = SupabaseClient(
    'https://xjzqjzqzqzqzqzqzqzqz.supabase.co',
    'public_anon_key',
  );

  Future<bool> checkIfCustomer(String userId) async {
    try{
      final response = await Supabase.instance.client
          .from('mcustomer')
          .select()
          .eq('user_id', userId)
          .single();
      debugPrint('response: $response');
      return true;
    }catch(e){
      return false;
    }
  }


  // sign in user button method
  void signInUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
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
    //   final response = await supabase.auth.signInWithPassword(
    //       password: passwordController.text.trim(),
    //       email: usernameController.text.trim());
    //   if (!mounted) return;

    //   final user = response.user;

    //   if (user != null) {
    //     // Proceed to check if the user is in the mcustomer table
    //     bool isCustomer = await checkIfCustomer(user.id);

    //     if (isCustomer) {
    //       // if (!mounted) Navigator.pop(context);
    //       // Navigate to customer home
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => HomeCustomer()),
    //       );
    //     } else {
    //       // if (!mounted) Navigator.pop(context);
    //       // showDialog(
    //       //   context: context, 
    //       //   builder: (context) {
    //       //     return ErrorDialog(errormsg: 'User not found. Please register as a customer first.');
    //       //   }
    //       // );
    //       // Handle case where user is not in mcustomer table
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => LoginPage(onTap: widget.onTap,)), // Or any other page
    //       );
    //     }
    //   }
    //   // Navigator.pop(context);
    //   // Navigator.pushReplacement(
    //   //     context,
    //   //     MaterialPageRoute(
    //   //         builder: (context) => HomeCustomer()));
    // } on AuthException catch (e) {
    //   // Dismiss the loading circle
    //   Navigator.pop(context);
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return ErrorDialog(errormsg: e.message ?? 'An error occurred');
    //     },
    //   );
    // }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      // If successful, pop the loading circle
      if(mounted){
        Navigator.pop(context);
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
            return ErrorDialog(errormsg: e.message ?? "An error occurred");
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

  // void signInUser() async {
  //   // print('Username: ${usernameController.text}');
  //   // print('Password: ${passwordController.text}');
  //   // sign in loading circle
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (context) {
  //   //     return const Center(
  //   //       child: CircularProgressIndicator(
  //   //         // valueColor: AlwaysStoppedAnimation<Color>(mainBlue),
  //   //       ),
  //   //     );
  //   //   },
  //   // );

  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: usernameController.text,
  //     password: passwordController.text
  //   );
  //   // Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: mainBlue,
      // backgroundColor: Colors.grey[200],
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

                // welcome back
                Text('Welcome Back, Traveler!',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                const SizedBox(
                  height: 20,
                ),

                // email
                LoginTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false,
                    iconInput: Icon(Icons.email)),
                const SizedBox(
                  height: 10,
                ),

                // password
                LoginTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    iconInput: Icon(Icons.lock)),
                const SizedBox(
                  height: 10,
                ),

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
                const SizedBox(
                  height: 20,
                ),

                // sign in button
                LoginButton(
                  onTap: signInUser,
                  buttontext: 'Sign In',
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
                    Text("Didn't have an account? "),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],

                ),
                // const SizedBox(height: 10,),
                // // seller login
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("A Travel Agent?"),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeSeller()));
                //       },
                //       child: Text(
                //         'Login Here',
                //         style: TextStyle(
                //             color: Colors.blue[700],
                //             fontWeight: FontWeight.bold),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
