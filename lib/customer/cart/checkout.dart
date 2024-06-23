import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
import 'package:intl/intl.dart';

class Checkout extends StatefulWidget {
  final String name;
  final String username;

  const Checkout({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  State<StatefulWidget> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}