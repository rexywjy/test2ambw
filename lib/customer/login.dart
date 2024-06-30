import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/components/errordialog.dart';
import 'package:test2ambw/components/squaretile.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/seller/index.dart';
import '../components/loginbutton.dart';
import '../components/loginTextField.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
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

  final Color mainBlue = const Color.fromARGB(255, 3, 174, 210);

  final Color mainBlue2 = const Color.fromARGB(255, 71, 147, 175);

  final Color mainYellow = Colors.amber;
  final Color mainYellow2 = const Color.fromARGB(255, 252, 171, 10);

  final Color mainPastelYellow = const Color.fromARGB(255, 254, 239, 173);

  // supabase client
  final _supabaseClient = SupabaseClient(
    'https://xjzqjzqzqzqzqzqzqzqz.supabase.co',
    'public_anon_key',
  );

  static Future<fauth.User?> signInWithGoogle({required BuildContext context}) async {
    fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
    fauth.User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final fauth.AuthCredential credential = fauth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final fauth.UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on fauth.FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  Future<bool> checkIfCustomer(String userId) async {
    try{
      final response = await Supabase.instance.client
          .from('mcustomer')
          .select()
          .eq('ID', userId)
          .single();
      debugPrint('response: $response');
      return true;
    }catch(e){
      return false;
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }


  // sign in user button method
  void signInUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      // Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(errormsg: "Please fill in all fields");
        },
      );
      return;
    }
    // Show the loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
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

      final sup = await supabase.from('mcustomer').select().eq('Username', usernameController.text);
      if(sup.length == 0){
        // Dismiss the loading circle
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(errormsg: "Invalid email or password");
          },
        );
        return;
      }
      final theemail = sup[0]['Email'];

      final credential = await fauth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: theemail,
        password: passwordController.text,
      );
      // If successful, pop the loading circle
      if(mounted){
        Navigator.pop(context);
      }
    } on fauth.FirebaseAuthException catch (e) {
      // Handle the error, show a message, etc.
      // print('Error: $e');
      // Dismiss the loading circle
      Navigator.pop(context);
      // Optionally, show an error dialog or a message to the user
      // print("Error code: " + e.code);
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
            return const ErrorDialog(errormsg: "Invalid email or password");
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
        // physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // logo
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.airplane_ticket_rounded,
                  size: 100,
                  color: Colors.amber,
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
                    hintText: 'Username',
                    obscureText: false,
                    iconInput: const Icon(Icons.person),
                    type: 'nospace',
                    themeAccent: mainYellow,
                  ),
                const SizedBox(
                  height: 10,
                ),
                // // email
                // LoginTextField(
                //     controller: usernameController,
                //     hintText: 'Email',
                //     obscureText: false,
                //     iconInput: const Icon(Icons.email),
                //     type: 'nospace'
                //   ),
                // const SizedBox(
                //   height: 10,
                // ),

                // password
                LoginTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    iconInput: const Icon(Icons.lock),
                    type: '',
                    themeAccent: mainYellow,
                  ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 80.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't have an account? "),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                              // backgroundColor: mainYellow,
                              color: mainYellow2,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  
                  ),
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
