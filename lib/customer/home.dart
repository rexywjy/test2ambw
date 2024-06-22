// ignore_for_file: prefer_const_constructors

// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'utils/bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test2ambw/components/carousel.dart';
import 'package:test2ambw/components/carouselDestination.dart';
import 'package:test2ambw/components/carouselHotel.dart';
import 'package:test2ambw/components/exploreMore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/customer/profile.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key); // Keeping MyApp const

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  // final int initialPageIndex;
  final String name;
  final String username;

  const MyHomePage({
    super.key,

    // this.initialPageIndex = 0,
    required this.name,
    required this.username,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var menuData;
  var selectedButton = 'tours';

  bool isFirstLoad = true;
  var nameProfile = "";

  // CustProfile custProfile = CustProfile(name: widget.name, username: widget.username,);

  Future<dynamic> fetchTourData(menuType) async {
    var resp = await Supabase.instance.client.from(menuType).select().limit(5);

    setState(() {
      menuData = resp;
    });

    return resp;
  }

  @override
  void initState() {
    fetchTourData("mtour");
    fetchName();
  }

  Future<void> fetchName() async {
    try {
      final response = await supabase
          .from('mcustomer')
          .select('Name')
          .eq('Email', FirebaseAuth.instance.currentUser!.email.toString());
      setState(() {
        this.nameProfile = response[0]['Name'];
      });
    } catch (e) {
      debugPrint("ERROR : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: <Widget>[
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(color: Colors.white),
            ),
            Container(
              width: double.infinity,
              height: 125,
              decoration: BoxDecoration(color: Color(0xFFFFA800)),
            ),
            Positioned(
              top: 100,
              left: (MediaQuery.of(context).size.width - 350) / 2,
              child: Container(
                child: Stack(children: <Widget>[
                  Container(
                    width: 350,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          )
                        ]),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeCustomer(
                                      initialPageIndex: 2,
                                      name: widget.name,
                                      username: widget.username,
                                    )),
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 8, right: 50),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 5),
                                    child: Text("Where to today?",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.italic)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 5),
                                    child: Text(
                                        // nameProfile,
                                        widget.name,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text("Points",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Text("3.560.000",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ]),
              ),
            )
          ]),
          Expanded(
            child:
                ListView(padding: const EdgeInsets.all(20), children: <Widget>[
              Text('Discover',
                  style: GoogleFonts.montserrat(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          fetchTourData('mtour');
                          selectedButton = 'tours';
                        },
                        child: Text(
                          "Tours",
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedButton == 'tours'
                                  ? Color(0xFFFFA800)
                                  : Colors.grey,
                              decoration: selectedButton == 'tours'
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor: Color(0xFFFFA800)),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          fetchTourData('mdestinations');
                          selectedButton = 'destinations';
                        },
                        child: Text(
                          "Destinations",
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedButton == 'destinations'
                                  ? Color(0xFFFFA800)
                                  : Colors.grey,
                              decoration: selectedButton == 'destinations'
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor: Color(0xFFFFA800)),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          fetchTourData('mhotel');
                          selectedButton = 'hotels';
                        },
                        child: Text(
                          "Hotels",
                          style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedButton == 'hotels'
                                  ? Color(0xFFFFA800)
                                  : Colors.grey,
                              decoration: selectedButton == 'hotels'
                                  ? TextDecoration.underline
                                  : null,
                              decorationColor: Color(0xFFFFA800)),
                        ),
                      )),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      fetchTourData('mhotel');
                      selectedButton = 'hotels';
                    },
                    child: Text(
                      "See More >>",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFA800),
                      ),
                    ),
                  )),
              //Placeholder for the carousel
              menuData == null
                  ? CircularProgressIndicator()
                  : selectedButton == 'tours'
                      ? ScrollImageCarousel(
                          menuData: menuData,
                        )
                      : selectedButton == 'destinations'
                          ? ScrollImageCarouselDestination(menuData: menuData)
                          : selectedButton == 'hotels'
                              ? ScrollImageCarouselHotel(menuData: menuData)
                              : CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Text('Explore More',
                    style: GoogleFonts.montserrat(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              exploreMore(),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavbar(),
    );
  }
}
