import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2ambw/components/singlesection.dart';
import 'package:test2ambw/customer/custhistory.dart';
import '../components/customlisttile.dart';

class CustProfile extends StatefulWidget {
  const CustProfile({super.key});

  @override
  State<CustProfile> createState() => _CustProfileState();
}

class _CustProfileState extends State<CustProfile> {
  bool _isDark = false;

  
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void goToHistory() {
    // Navigator.pushNamed(context, '/transactions');
    Navigator.push(
      context,
      MaterialPageRoute(
          // builder: (context) => DetailScreen(note: note, isNew: isNew)),
          builder: (context) => CustHistory()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  const Text(
                    "Richie Lorie",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     FloatingActionButton.extended(
                  //       onPressed: () {},
                  //       heroTag: 'follow',
                  //       elevation: 0,
                  //       label: const Text("Follow"),
                  //       icon: const Icon(Icons.person_add_alt_1),
                  //     ),
                  //     const SizedBox(width: 16.0),
                  //     FloatingActionButton.extended(
                  //       onPressed: () {},
                  //       heroTag: 'mesage',
                  //       elevation: 0,
                  //       backgroundColor: Colors.red,
                  //       label: const Text("Message"),
                  //       icon: const Icon(Icons.message_rounded),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                  // const _ProfileInfoRow()
                ],
              ),
            ),
          ),
          SingleSection(
            title: "General",
            children: [
              // CustomListTile(
              //     title: "Dark Mode",
              //     icon: Icons.dark_mode_outlined,
              //     trailing: Switch(
              //         value: _isDark,
              //         onChanged: (value) {
              //           // setState(() {
              //           //   _isDark = value;
              //           // });
              //         })),
                CustomListTile(
                  title: "Transactions History",
                  icon: Icons.view_list_outlined,
                  // method: () => Navigator.pushNamed(context, '/transactions')
                  method: goToHistory,
                ),
                const CustomListTile(
                  title: "Notifications",
                  icon: Icons.notifications_none_rounded),
                const CustomListTile(
                  title: "Security Status",
                  icon: Icons.shield_outlined
                  ),
            ],
          ),
          const Divider(),
          // const SingleSection(
          //   title: "Organization",
          //   children: [
          //     CustomListTile(
          //         title: "Profile", icon: Icons.person_outline_rounded),
          //     CustomListTile(
          //         title: "Messaging", icon: Icons.message_outlined),
          //     CustomListTile(
          //         title: "Calling", icon: Icons.phone_outlined),
          //     CustomListTile(
          //         title: "People", icon: Icons.contacts_outlined),
          //     CustomListTile(
          //         title: "Calendar", icon: Icons.calendar_today_rounded)
          //   ],
          // ),
          // const Divider(),
          SingleSection(
            children: [
              const CustomListTile(
                title: "Help & Feedback",
                icon: Icons.help_outline_rounded),
              const CustomListTile(
                title: "About", icon: Icons.info_outline_rounded),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.red,
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 30,),
                    title: const Text(
                      "Sign out",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)
                    ),
                    onTap: signUserOut,
                    selected: true,
                  ),
                )
              ),
              // ListTile(
              //   tileColor: Colors.red,
              //   title: Text(
              //     "Sign out",
              //     style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,)
              //   ),
              //   leading: Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 30,),
              //   // trailing: trailing,
              //   onTap: signUserOut,
              // ),
              // CustomListTile(
              //   title: "Sign out", 
              //   icon: Icons.exit_to_app_rounded,
              //   method: signUserOut
              // ),
            ],
          ),
          
        ],
      ),
    );
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