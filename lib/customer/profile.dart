import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/components/singlesection.dart';
import 'package:test2ambw/customer/custhistory.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/others/auth.dart';
import 'package:test2ambw/seller/index.dart';
import 'package:test2ambw/seller/profileorproduct.dart';
import 'package:test2ambw/seller/register.dart';
import '../components/customlisttile.dart';
import 'package:hexcolor/hexcolor.dart';

class CustProfile extends StatefulWidget {
  final String name;
  final String username;
  const CustProfile({
    super.key,
    required this.name,
    required this.username,
    });

  @override
  State<CustProfile> createState() => _CustProfileState();
}
final supabase = Supabase.instance.client;
class _CustProfileState extends State<CustProfile> {
  bool _isDark = false;

  bool isFirstLoad = true;

  var nameProfile = '';

  final Color mainAmber = HexColor('#FFBF00');
  
  // @override
  // void initState() {
  //   // debugPrint("duar");
  //   super.initState();
  //   fetchName();
  // }

  

  Future<void> fetchName() async {
    // debugPrint("FETCHING NAME");
    // debugPrint("USERR : "+FirebaseAuth.instance.currentUser!.email.toString());
    try{
      final response = await supabase
          .from('mcustomer')
          .select('Name')
          .eq('Email', FirebaseAuth.instance.currentUser!.email.toString())
          // .execute()
          ;
      // debugPrint("RESPONSE : "+response[0]['Name'].toString());
      // if (response.length == 0) {
      //   // Handle error
      //   return;
      // }

      // final List<dynamic> data = response as List<dynamic>;
      // if (data.isNotEmpty) {
          setState(() {
            this.nameProfile = response[0]['Name'];
          });
      // }
    }catch(e){
      debugPrint("ERROR : "+e.toString());
    }
  }

  void signUserOut() async {
    debugPrint('Signing out...');
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
    // await supabase.auth.signOut();
    // if(!mounted) return;
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  void goToHistory() {
    // Navigator.pushNamed(context, '/transactions');
    Navigator.push(
      context,
      MaterialPageRoute(
          // builder: (context) => DetailScreen(note: note, isNew: isNew)),
          builder: (context) => CustHistory(username: widget.username)),
    );
  }

  Future<void> checkIfSeller() async {
    final email = FirebaseAuth.instance.currentUser!.email.toString();
    final userr = await supabase
        .from('mcustomer')
        .select('ID')
        .eq('Email', email)
        // .execute()
        ;
    final userid = userr[0]['ID'];
    final response = await supabase
        .from('mseller')
        .select()
        .eq('CustID', userid)
        .neq('Status', 0)
        // .execute()
        ;

    if (response.isNotEmpty) {
      // Email found, navigate to HomepageSeller
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeSeller()),
      );
    } else {
      
      final response = await supabase
        .from('mseller')
        .select()
        .eq('CustID', userid)
        .eq('Status', 0)
        // .execute()
        ;
      if(response.isNotEmpty){
        // Email not found, navigate to SellerRegister
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SellerRegister(storestatus: 0, userid: userid)),  
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SellerRegister(storestatus: -1, userid: userid)),  
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    // if(isFirstLoad) {
    //   fetchName();
    //   isFirstLoad = false;
    // }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            'https://static1.cbrimages.com/wordpress/wp-content/uploads/2021/07/JK-Simmons-J-Jonah-Jameson-Header-1.jpg')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@'+widget.username,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleSection(
                    title: "Buyer",
                    children: [
                      CustomListTile(
                        title: "Transactions History",
                        icon: Icons.view_list_outlined,
                        method: goToHistory,
                      ),
                      const CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    ],
                  ),
                  const Divider(),
                  SingleSection(
                    title: "Seller",
                    children: [
                      CustomListTile(
                        title: "My Products", 
                        icon: Icons.shopping_bag_outlined,
                        method: checkIfSeller,
                      ),
                      CustomListTile(
                        title: "Seller Profile", 
                        icon: Icons.person_outline_rounded,
                        method: checkIfSeller,
                      ),
                    ],
                  ),
                  const Divider(),
                  SingleSection(
                    children: [
                      const CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                      const CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
                      const Divider(),
                      ListTile(
                        title: Text(
                          "Sign out",
                          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w900,)
                        ),
                        leading: Icon(Icons.exit_to_app_rounded, color: Colors.red, size: 25,),
                        onTap: signUserOut,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //   child: Scaffold(
    //     body: ListView(
    //       children: [
    //         Expanded(
    //           // flex: 3,
    //           child: Padding(
    //             padding: EdgeInsets.all(8.0),
    //             child: Column(
    //               children: [
    //                 const SizedBox(height: 12),
    //                 Align(
    //                   alignment: Alignment.bottomCenter,
    //                   child: SizedBox(
    //                     width: 150,
    //                     height: 150,
    //                     child: Stack(
    //                       fit: StackFit.expand,
    //                       children: [
    //                         Container(
    //                           decoration: const BoxDecoration(
    //                             color: Colors.black,
    //                             shape: BoxShape.circle,
    //                             image: DecorationImage(
    //                                 fit: BoxFit.cover,
    //                                 image: NetworkImage(
    //                                     'https://static1.cbrimages.com/wordpress/wp-content/uploads/2021/07/JK-Simmons-J-Jonah-Jameson-Header-1.jpg')),
    //                           ),
    //                         ),
    //                         // Positioned(
    //                         //   bottom: 0,
    //                         //   right: 0,
    //                         //   child: CircleAvatar(
    //                         //     radius: 20,
    //                         //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //                         //     child: Container(
    //                         //       margin: const EdgeInsets.all(8.0),
    //                         //       decoration: const BoxDecoration(
    //                         //           color: Colors.green, shape: BoxShape.circle),
    //                         //     ),
    //                         //   ),
    //                         // ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 16),
    //                 Text(
    //                   // nameProfile,
    //                   widget.name,
    //                   style: const TextStyle(
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 Text(
    //                   // '@'+nameProfile,
    //                   '@'+widget.username,
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                     // fontStyle: FontStyle.italic,
    //                     color: Colors.grey,
    //                   ),
    //                 ),
    //                 // Row(
    //                 //   mainAxisAlignment: MainAxisAlignment.center,
    //                 //   children: [
    //                 //     FloatingActionButton.extended(
    //                 //       onPressed: () {},
    //                 //       heroTag: 'follow',
    //                 //       elevation: 0,
    //                 //       label: const Text("Follow"),
    //                 //       icon: const Icon(Icons.person_add_alt_1),
    //                 //     ),
    //                 //     const SizedBox(width: 16.0),
    //                 //     FloatingActionButton.extended(
    //                 //       onPressed: () {},
    //                 //       heroTag: 'mesage',
    //                 //       elevation: 0,
    //                 //       backgroundColor: Colors.red,
    //                 //       label: const Text("Message"),
    //                 //       icon: const Icon(Icons.message_rounded),
    //                 //     ),
    //                 //   ],
    //                 // ),
    //                 // const SizedBox(height: 16),
    //                 // const _ProfileInfoRow()
    //               ],
    //             ),
    //           ),
    //         ),
    //         SingleSection(
    //           title: "Buyer",
    //           children: [
    //             // CustomListTile(
    //             //     title: "Dark Mode",
    //             //     icon: Icons.dark_mode_outlined,
    //             //     trailing: Switch(
    //             //         value: _isDark,
    //             //         onChanged: (value) {
    //             //           // setState(() {
    //             //           //   _isDark = value;
    //             //           // });
    //             //         })),
    //               CustomListTile(
    //                 title: "Transactions History",
    //                 icon: Icons.view_list_outlined,
    //                 // method: () => Navigator.pushNamed(context, '/transactions')
    //                 method: goToHistory,
    //               ),
    //               const CustomListTile(
    //                 title: "Notifications",
    //                 icon: Icons.notifications_none_rounded),
    //           ],
    //         ),
    //         const Divider(),
    //         SingleSection(
    //           title: "Seller",
    //           children: [
    //             CustomListTile(
    //                 title: "My Products", 
    //                 icon: Icons.shopping_bag_outlined,
    //                 method: checkIfSeller,
    //               ),
    //             CustomListTile(
    //                 title: "Seller Profile", 
    //                 icon: Icons.person_outline_rounded,
    //                 method: checkIfSeller,
    //               ),
    //             // CustomListTile(
    //             //     title: "Calling", icon: Icons.phone_outlined),
    //             // CustomListTile(
    //             //     title: "People", icon: Icons.contacts_outlined),
    //             // CustomListTile(
    //             //     title: "Calendar", icon: Icons.calendar_today_rounded)
    //           ],
    //         ),
    //         const Divider(),
    //         SingleSection(
    //           children: [
    //             const CustomListTile(
    //               title: "Help & Feedback",
    //               icon: Icons.help_outline_rounded),
    //             const CustomListTile(
    //               title: "About", icon: Icons.info_outline_rounded),
    //             // ClipRRect(
    //             //   borderRadius: const BorderRadius.only(
    //             //     topLeft: Radius.circular(20),
    //             //     bottomLeft: Radius.circular(20),
    //             //     bottomRight: Radius.circular(20),
    //             //     topRight: Radius.circular(20),
    //             //   ),
    //             //   child: Container(
    //             //     color: Colors.red,
    //             //     child: ListTile(
    //             //       leading: Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 30,),
    //             //       title: const Text(
    //             //         "Sign out",
    //             //         style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)
    //             //       ),
    //             //       onTap: signUserOut,
    //             //       selected: true,
    //             //     ),
    //             //   )
    //             // ),
    //             const Divider(),
    //             ListTile(
    //               // tileColor: Colors.red,
    //               title: Text(
    //                 "Sign out",
    //                 style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w900,)
    //               ),
    //               leading: Icon(Icons.exit_to_app_rounded, color: Colors.red, size: 25,),
    //               // trailing: Icon(Icons.exit_to_app_rounded, color: Colors.red, size: 25,),
    //               // trailing: trailing,
    //               onTap: signUserOut,
    //             ),
    //             // CustomListTile(
    //             //   title: "Sign out", 
    //             //   icon: Icons.exit_to_app_rounded,
    //             //   method: signUserOut
    //             // ),
    //           ],
    //         ),
            
    //       ],
    //     ),
    //   ),
    // );
  }
}


class _TopPortion extends StatelessWidget {
  _TopPortion({Key? key}) : super(key: key);
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xff0043ba), Color(0xff006df1)]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
        
      ],
    );
  }
}