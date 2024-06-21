// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:test2ambw/customer/index.dart';
// import 'package:test2ambw/customer/login.dart';
// import 'package:test2ambw/customer/loginorregister.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           // user is loggen in
//           debugPrint("SNAPSHOT DATA : "+snapshot.data.toString());
//           final session = snapshot.data?.;
//           if(snapshot.hasData){
//             return FutureBuilder<String>(
//               future: checkUserRole(session.user!.email!),
//               builder: (context, AsyncSnapshot<String> response) {
//                 debugPrint("RESPONSE DATA : "+response.data.toString());
//                 // debugPrint(response.toString());
//                 if (response.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (response.hasError || response.data == 'error') {
//                   return Center(child: Text('Error: Unable to determine user role.'));
//                 } else if (response.data == 'logcustomer') {
//                   return HomeCustomer();
//                 } else if (response.data == 'logseller') {
//                   return HomeCustomer();
//                 } else if (response.data == 'customer') {
//                   return LoginOrRegisterPage();
//                 } else if (response.data == 'seller') {
//                   return HomeCustomer();
//                 } else {
//                   return Center(child: Text('Unknown user role.'));
//                 }
//               },
//             );
//           }else{
//             // return LoginPage();
//             return LoginOrRegisterPage();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/customer/loginorregister.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is loggen in
          debugPrint("SNAPSHOT DATA : "+snapshot.data.toString());
          if(snapshot.hasData){
            return HomeCustomer();
          }else{
            // return LoginPage();
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
// 
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:test2ambw/customer/index.dart';
// import 'package:test2ambw/customer/login.dart';
// import 'package:test2ambw/customer/loginorregister.dart';
// // import 'package:test2ambw/seller/sellerhome.dart';
// // import 'package:test2ambw/seller/sellerlogin.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   Future<String> checkUserRole(String email) async {
//     try {

//       final customerResponse = await Supabase.instance.client
//           .from('mcustomer')
//           .select()
//           .eq('Email', email)
//           .eq('IsLoggedIn', 1)
//           // .single()
//           ;
//       debugPrint(email+"CUSTOMER RESPONSE : "+customerResponse.toString());
//       if (customerResponse.length > 0) {

//         // if(customerResponse[0]['IsLoggedIn'] == 1){
//         //   return 'logcustomer';
//         // }
//         return 'customer';
//       }

//       // Check if user is a seller
//       final sellerResponse = await Supabase.instance.client
//           .from('mseller')
//           .select()
//           .eq('Email', email)
//           .eq('IsLoggedIn', 1)
//           // .single()
//           ;
//       debugPrint(email+"CUSTOMER RESPONSE : "+customerResponse.toString());
//       if (sellerResponse.length > 0) {
//         // if(sellerResponse[0]['IsLoggedIn'] == 1){
//         //   return 'logseller';
//         // }
//         return 'seller';
//       }


//       return 'unknown';
//     } catch (e) {
//       return 'error';
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<AuthState>(
//         stream: Supabase.instance.client.auth.onAuthStateChange,
//         builder: (context, snapshot) {
//           final session = snapshot.data?.session;
//           if (session != null && session.user != null) {
//             // debugPrint("SESSION EMAIL : "+session.user!.email!);
//             return FutureBuilder<String>(
//               future: checkUserRole(session.user!.email!),
//               builder: (context, AsyncSnapshot<String> response) {
//                 debugPrint("RESPONSE DATA : "+response.data.toString());
//                 // debugPrint(response.toString());
//                 if (response.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (response.hasError || response.data == 'error') {
//                   return Center(child: Text('Error: Unable to determine user role.'));
//                 } else if (response.data == 'customer') {
//                   return HomeCustomer();
//                 } else if (response.data == 'seller') {
//                   return HomeCustomer();
//                 // } else if (response.data == 'customer') {
//                 //   return LoginOrRegisterPage();
//                 // } else if (response.data == 'seller') {
//                 //   return HomeCustomer();
//                 } else if (response.data == 'unknown') {
//                   return LoginOrRegisterPage();
//                 } else {
//                   return Center(child: Text('Unknown user role.'));
//                 }
//               },
//             );
//           } else {
//             return LoginOrRegisterPage();
//           }
//         },
//       ),
//     );
//   }
// }

// // import 'package:firebase_auth/firebase_auth.dart' as fbauth;
// // import 'package:flutter/material.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:test2ambw/customer/index.dart';
// // import 'package:test2ambw/customer/login.dart';
// // import 'package:test2ambw/customer/loginorregister.dart';

// // class AuthPage extends StatelessWidget {
// //   const AuthPage({super.key});

// //   Future<String> checkUserRole(String userId) async {
// //     try {
// //       // Check if user is a customer
// //       final customerResponse = await Supabase.instance.client
// //           .from('mcustomer')
// //           .select()
// //           .eq('ID', userId)
// //           // .single()
// //           ;

// //       if (customerResponse.length > 0) {
// //         return 'customer';
// //       }

// //       // Check if user is a seller
// //       final sellerResponse = await Supabase.instance.client
// //           .from('mseller')
// //           .select()
// //           .eq('ID', userId)
// //           // .single()
// //           ;

// //       if (sellerResponse.length > 0) {
// //         return 'seller';
// //       }

// //       return 'unknown';
// //     } catch (e) {
// //       return 'error';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // body: StreamBuilder<fbauth.User?>(
// //       //   stream: fbauth.FirebaseAuth.instance.authStateChanges(),
// //       //   builder: (context, snapshot) {
// //       //     // user is loggen in
// //       //     if(snapshot.hasData){
// //       //       return HomeCustomer();
// //       //     }else{
// //       //       // return LoginPage();
// //       //       return LoginOrRegisterPage();
// //       //     }
// //       //   },
// //       body: StreamBuilder<AuthState>(
// //         stream: Supabase.instance.client.auth.onAuthStateChange,
// //         builder: (context, snapshot) {
// //           final session = snapshot.data?.session;
// //           if (session != null && session.user != null) {
// //             return FutureBuilder<bool>(
// //               future: checkIfHaveAccount(session.user!.id),
// //               builder: (context, AsyncSnapshot<bool> response) {
// //                 if (response.connectionState == ConnectionState.waiting) {
// //                   return Center(child: CircularProgressIndicator());
// //                 } else if (response.hasError || !response.data!) {
// //                   // return Center(child: Text('Error: Not a customer or other error.'));
// //                   // check if user is a seller
// //                   if()
// //                 } else {
// //                   return HomeCustomer();
// //                 }
// //               },
// //             );
// //           } else {
// //             return LoginOrRegisterPage();
// //           }
// //         }
// //         ,
// //       ),
// //     );
// //   }
// // }