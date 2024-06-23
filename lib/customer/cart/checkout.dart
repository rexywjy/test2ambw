import 'dart:async';
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
import 'package:test2ambw/customer/cart/success_dialog.dart';
import 'dart:convert';

class Checkout extends StatefulWidget {
  final String name;
  final String username;
  final List<CheckoutItem> items;

  const Checkout(
      {super.key,
      required this.name,
      required this.username,
      required this.items});

  @override
  State<StatefulWidget> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  // final List<CheckoutItem> items = [
  //   CheckoutItem(name: 'Item 1', quantity: 2, price: 10.0),
  //   CheckoutItem(name: 'Item 2', quantity: 1, price: 20.0),
  //   CheckoutItem(name: 'Item 3', quantity: 3, price: 5.0),
  // ];

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  int get total {
    return widget.items.fold(0, (sum, item) => sum + item.productSubtotal);
  }

  // Future prepareData() async {
  //   final response = await Supabase.instance.client
  //     .from('mtransaction')
  //     .select('*')
  //     .eq('user_id', widget.username);

  //   print("JSON ENCODE");
  //   for (var x in response) {
  //     print(x['transaction_product']);
  //   }

  // }

  Future clearCart() async {
    for (var x in widget.items) {
      final response_item = await Supabase.instance.client
        .from('mcart')
        .select()
        .eq('cart_id', x.cartId);
      
      var pt = response_item[0]['product_type'];
      var pId = response_item[0]['product_id'];
      final check_qty;

      if (pt == 'dhotel') {
        check_qty = await Supabase.instance.client
          .from('dhotel')
          .select()
          .eq('DHotelID', pId);
        await Supabase.instance.client
          .from('dhotel')
          .update({
            'MaxQuota': check_qty[0]['MaxQuota'] - x.productQty
          })
          .eq('DHotelID', pId);
      } else if (pt == 'mdestinations') {
        check_qty = await Supabase.instance.client
          .from('mdestinations')
          .select()
          .eq('id', pId);
        await Supabase.instance.client
          .from('mdestinations')
          .update({
            'MaxQuota': check_qty[0]['MaxQuota'] - x.productQty
          })
          .eq('id', pId);
      } else if (pt == 'mtour') {
        check_qty = await Supabase.instance.client
          .from('mtour')
          .select()
          .eq('TourID', pId);
        await Supabase.instance.client
          .from('mtour')
          .update({
            'MaxQuota': check_qty[0]['MaxQuota'] - x.productQty
          })
          .eq('TourID', pId);
      }


    }

    for (var i in widget.items) {
      final response_cart = await Supabase.instance.client
        .from('mcart')
        .delete()
        .eq('cart_id', i.cartId);
        
    }

    if (mounted) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                msg: 'Success',
                msg_detail: 'Transaction Successfully.',
              );
            },
          ).then((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeCustomer(
                  initialPageIndex: 0,
                  name: widget.name,
                  username: widget.username,
                ),
              ),
              (route) => false,
            );
          });
        });
      });
    }
  }

  Future confirmTransaction(productJson) async {
    
    var user_id = widget.username;
    var transaction_total = total;
    var transaction_product = productJson;

    final response = await Supabase.instance.client
      .from('mtransaction')
      .insert({
        'user_id': user_id,
        'transaction_total': transaction_total,
        'transaction_product': transaction_product
      })
      .select();

    clearCart();
  }
  
  String encodeItemsToJson(List<CheckoutItem> items) {
    List<Map<String, dynamic>> itemsList = items.map((item) => item.toJson()).toList();
    return jsonEncode(itemsList);
  }

  List<CheckoutItem> decodeItemsFromJson(String jsonString) {
    List<dynamic> itemsList = jsonDecode(jsonString);
    return itemsList.map((json) => CheckoutItem.fromJson(json)).toList();
  }

  // to decode
  // List<CheckoutItem> items = decodeItemsFromJson(jsonString);
  // for (var item in items) {
  //   print('Product Name: ${item.productName}, Quantity: ${item.productQty}, Price: ${item.productPrice}, Subtotal: ${item.productSubtotal}');
  // }

  @override
  void initState() {
    // prepareData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Checkout Details',
            style: GoogleFonts.montserrat(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xFFFFA800),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Material(
                    elevation: 5.0,
                    shadowColor: Colors.black,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0,),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                          title: Text(
                            item.productName,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.productQty}x @${convertToIdr(item.productPrice, 0)}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Text(
                                '${convertToIdr(item.productSubtotal, 0)}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )));
              },
            ),
          ),
          Container(
              // color: Colors.white,
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    spreadRadius: 1, // Spread radius
                    blurRadius: 10, // Blur radius
                    offset: Offset(0, -5), // Offset in the x (0) and y (-5) directions
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total:",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                        Text(
                          '${convertToIdr(total, 0)}',
                          style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFFA800)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFA800),
                      ),
                      onPressed: () {
                        String itemsJson = encodeItemsToJson(widget.items);
                        print(itemsJson);
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
                        confirmTransaction(itemsJson);
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HomeCustomer(
                        //       initialPageIndex: 0,
                        //       name: widget.name,
                        //       username: widget.username,
                        //     ),
                        //   ),
                        //   (route) =>
                        //       false, 
                        // );
                      },
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
      
    );
  }
}
