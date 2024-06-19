// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'utils/bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/carousel.dart';
import 'package:travel_app/carouselDestination.dart';
import 'package:travel_app/carouselHotel.dart';
import 'package:travel_app/utils/bottom_navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ydscvaytbbvwrofeojpj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlkc2N2YXl0YmJ2d3JvZmVvanBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY1NTMyNTgsImV4cCI6MjAzMjEyOTI1OH0.R1YdW0VOhciEb6aO1ljiUT1iZrKilWoEoi4_K9xN_Y8',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Keeping MyApp const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var menuData;
  var selectedButton = 'tours';

  Future<dynamic> fetchTourData(menuType) async {
    var resp = await Supabase.instance.client.from(menuType).select();
    print(resp);

    setState(() {
      menuData = resp;
    });

    return resp;
  }

  @override
  void initState() {
    fetchTourData("mtour2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rodex'),
        backgroundColor: Color(0xFFFFA800),
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: <Widget>[
        Text('Discover',
            style: GoogleFonts.montserrat(
                fontSize: 30, fontWeight: FontWeight.bold)),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    fetchTourData('mtour2');
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.hotel,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Hotels",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Attractions",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.boxOpen,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Tours",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.plane,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Airplane",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.plane,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Airplane",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.plane,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Airplane",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.plane,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Airplane",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFA800),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: FaIcon(
                          FontAwesomeIcons.plane,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  Text(
                    "Airplane",
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ]),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
