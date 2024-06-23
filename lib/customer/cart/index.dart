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


class Cart extends StatefulWidget {
  final String name;
  final String username;

  const Cart({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  State<StatefulWidget> createState() => _CartState();
}

class Item {
  final int id;
  final String name;
  final String imageUrl;
  int quantity;
  int price;
  bool isSelected;

  Item({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.isSelected,
  });
}

class _CartState extends State<Cart> {
  

  List<Item> items = [];

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  int get total {
    return items.where((item) => item.isSelected).fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future minusQty(cartIdMinus) async {
    final existingItemResponse = await Supabase.instance.client
          .from('mcart')
          .select()
          .eq('cart_id', cartIdMinus);
    int currentQuantity = existingItemResponse[0]['quantity'] as int;
    if (currentQuantity > 1) {
      final response = await Supabase.instance.client
        .from('mcart')
        .update({
          'quantity': currentQuantity - 1
        })
        .eq('cart_id', cartIdMinus);
    } else {
      final response = await Supabase.instance.client
        .from('mcart')
        .delete()
        .eq('cart_id', cartIdMinus);
      // setState(() {
        fetchCartItems();
      // });
    }
    
  }

  Future plusQty(cartIdPlus) async {
    final existingItemResponse = await Supabase.instance.client
          .from('mcart')
          .select()
          .eq('cart_id', cartIdPlus);
    int currentQuantity = existingItemResponse[0]['quantity'] as int;
    final response = await Supabase.instance.client
      .from('mcart')
      .update({
        'quantity': currentQuantity + 1
      })
      .eq('cart_id', cartIdPlus);
  }

  Future changeSelected(cartIdSelected) async {
     final existingItemResponse = await Supabase.instance.client
          .from('mcart')
          .select()
          .eq('cart_id', cartIdSelected);
    int currentStatus = existingItemResponse[0]['is_selected'] as int;
    final response = await Supabase.instance.client
        .from('mcart')
        .update({
          'is_selected': currentStatus == 1 ? 0 : 1
        })
        .eq('cart_id', cartIdSelected);
    setState(() {
      items.forEach((item) {
        if (item.id == cartIdSelected) item.isSelected = currentStatus == 1 ? false : true;
      });
    });
  }

  Future checkoutItem() async {
    List<Map<String, dynamic>> coList = [];
    print('Item Checkout:');
    for (var x in items) {
      if (x.isSelected == true) {
        coList.add({'product_id': x.id, 'product_name': x.name, 'product_qty': x.quantity, 'product_price': x.price, 'product_subtotal': x.quantity * x.price, 'product_img': x.imageUrl});
      }
    }

    // for (var y in coList) {
    //   print(y);
    // }
    print('Total: ' + total.toString());
  }

  Future fetchCartItems() async {
    items.clear();

    var response = await Supabase.instance.client
      .from('mcart')
      .select('*')
      .eq('user_id', widget.username)
      .order('cart_id', ascending: true);
    
    print(response);

    for (var product in response) {
      String productType = product['product_type'];
      int qty = product['quantity'];
      String name = 'Item Dummy';
      int price = 0;
      String img = 'https://via.placeholder.com/150';
      // print(productType);
      // print(qty);

      if (productType == 'dhotel') {
        var responseDH = await Supabase.instance.client
          .from('dhotel')
          .select()
          .eq('DHotelID', product['product_id']);
        print(responseDH);
        var responseMH = await Supabase.instance.client
          .from('mhotel')
          .select()
          .eq('HotelID', responseDH[0]['HotelID']);
        name = responseMH[0]['NamaHotel'] + '-' + responseDH[0]['Tipe'];
        price = qty * responseDH[0]['Harga'] as int;
        img = responseMH[0]['image_url'];
      } else if (productType == 'mdestinations') {
        var responseMD = await Supabase.instance.client
          .from('mdestinations')
          .select()
          .eq('id', product['product_id']);
        print(responseMD);
        name = responseMD[0]['attraction_name'];
        price = qty * responseMD[0]['Price'] as int;
        img = responseMD[0]['image_url'];
      } else if (productType == 'mtour') {
        var responseMT = await Supabase.instance.client
          .from('mtour')
          .select()
          .eq('TourID', product['product_id']);
        print(responseMT);
        name = responseMT[0]['NamaTour'];
        price = qty * responseMT[0]['Price'] as int;
        img = responseMT[0]['image_url'];
      }

      setState(() {
        items.add(Item(id: product['cart_id'], name: name, imageUrl: img, quantity: qty, price: price, isSelected: product['is_selected'] as int == 1 ? true : false));
      });
      // items.add(Item(name: name, imageUrl: img, quantity: qty, price: price, isSelected: product['is_selected'] as int == 1 ? true : false));
    }

    
  }

  @override
  void initState() {
    fetchCartItems();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Shopping Cart', 
            style: GoogleFonts.montserrat(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white
            )
          ),
        ),
        backgroundColor: Color(0xFFFFA800)
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 2.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Color(0xFFFFA800),
                              value: item.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  changeSelected(item.id);
                                  item.isSelected = value!;
                                });
                              },
                            ),
                            Image.network(
                              item.imageUrl,
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8.0),
                                  Text(convertToIdr(item.price, 0), style: TextStyle(fontSize: 16.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Subtotal: ${convertToIdr(item.quantity * item.price, 0)}',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(item.quantity == 1 ? Icons.delete_outline : Icons.remove_circle_outline, color: item.quantity == 1 ? Colors.red : null,),
                              onPressed: () {
                                minusQty(item.id);
                                setState(() {
                                  if (item.quantity > 1) item.quantity--;
                                });
                              },
                            ),
                            Text(item.quantity.toString(), style: TextStyle(fontSize: 18.0)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                plusQty(item.id);
                                setState(() {
                                  item.quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (items.any((item) => item.isSelected))
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
                        checkoutItem();
                      },
                      child: Text(
                        'Checkout',
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