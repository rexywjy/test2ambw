// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:test2ambw/others/auth.dart';
// import 'package:test2ambw/customer/login.dart';
// import '../../firebase_options.dart';
// import '../index.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:test2ambw/customer/profile.dart';

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

  double get total {
    return items.where((item) => item.isSelected).fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future minusQty(cartIdMinus) async {
    final existingItemResponse = await Supabase.instance.client
          .from('mcart')
          .select()
          .eq('cart_id', cartIdMinus);
    int currentQuantity = existingItemResponse[0]['quantity'] as int;
    final response = await Supabase.instance.client
      .from('mcart')
      .update({
        'quantity': currentQuantity - 1
      })
      .eq('cart_id', cartIdMinus);
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
        'quantity': currentQuantity - 1
      })
      .eq('cart_id', cartIdPlus);
  }

  Future changeSelected(cartIdSelected) async {
    
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
      print(productType);
      print(qty);

      if (productType == 'dhotel') {
        var responseMH = await Supabase.instance.client
          .from('dhotel')
          .select()
          .eq('HotelID', product['product_id']);
        print(responseMH);
        // name = responseMH[0]['attraction_name'];
        price = qty * responseMH[0]['Price'] as int;
        // img = responseMH[0]['image_url'];
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
              fontWeight: FontWeight.bold
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
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: item.isSelected,
                              onChanged: (bool? value) {
                                setState(() {
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
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                minusQty(item.id);
                                setState(() {
                                  if (item.quantity > 1) item.quantity--;
                                });
                              },
                            ),
                            Text(item.quantity.toString(), style: TextStyle(fontSize: 18.0)),
                            IconButton(
                              icon: Icon(Icons.add),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Total: ${convertToIdr(total, 0)}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Implement your checkout logic here
                    },
                    child: Text('Checkout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

}