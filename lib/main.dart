// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'utils/bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/carousel.dart';
import 'package:travel_app/utils/bottom_navbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jckbqnbwxuvspcdowcrm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impja2JxbmJ3eHV2c3BjZG93Y3JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg3MDU2MTEsImV4cCI6MjAzNDI4MTYxMX0.yrhPSjsoWmIxSWqk0tXccjqYn7L9DJ2FbEMBK2FeGPo',
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

class MyHomePage extends StatelessWidget {
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
                child: Text(
                  "Tours",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Destinations",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "Hotels",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )),
          ],
        ),
        //Placeholder for the carousel
        ScrollImageCarousel(),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFFFFA800),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Text(
                  "Hotels",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Text(
                  "Airplanes",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Text(
                  "Tours",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Text(
                  "Destinations",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Text(
                    "Hotels",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 10),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 10),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        )
      ]),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
