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
import 'package:test2ambw/customer/cart/index.dart';
import 'package:test2ambw/customer/cart/checkout_item.dart';

class Checkout extends StatefulWidget {
  final String name;
  final String username;
  final List<CheckoutItem> items;

  const Checkout({
    super.key,
    required this.name,
    required this.username,
    required this.items
  });

  @override
  State<StatefulWidget> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  // final List<CheckoutItem> items = [
  //   CheckoutItem(name: 'Item 1', quantity: 2, price: 10.0),
  //   CheckoutItem(name: 'Item 2', quantity: 1, price: 20.0),
  //   CheckoutItem(name: 'Item 3', quantity: 3, price: 5.0),
  // ];

  Future cekData() async {
    for (var x in widget.items) {
      print(x.productName);
    }
  }

  @override
  void initState() {
    cekData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text(
      //       'Checkout Details',
      //       style: GoogleFonts.montserrat(
      //         fontSize: 25,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      //   backgroundColor: Color(0xFFFFA800),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white,),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: widget.items.length,
      //         itemBuilder: (context, index) {
      //           final item = widget.items[index];
      //           return ListTile(
      //             title: Text(item['qty']),
      //             subtitle: Text('Quantity: ${item.quantity}'),
      //             trailing: Text('\$${item.subtotal.toStringAsFixed(2)}'),
      //           );
      //         },
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: SizedBox(
      //         width: double.infinity, // Make button take full width
      //         child: ElevatedButton(
      //           onPressed: () {
      //             // Handle order action
      //             // ScaffoldMessenger.of(context).showSnackBar(
      //             //   SnackBar(content: Text('Order placed successfully!')),
      //             // );
      //             Navigator.pushAndRemoveUntil(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => HomeCustomer(
      //                   initialPageIndex: 0,
      //                   name: widget.name,
      //                   username: widget.username,
      //                 ),
      //               ),
      //               (route) => false, // This prevents going back to the previous page
      //             );
      //           },
      //           child: Text('Order'),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}