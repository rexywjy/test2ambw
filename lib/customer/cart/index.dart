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
import 'package:test2ambw/customer/cart/warning_dialog.dart';
import 'package:test2ambw/customer/cart/checkout.dart';
import 'package:test2ambw/customer/cart/checkout_item.dart';


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
        check_avail_item();
      // });
    }
    
  }

  Future plusQty(cartIdPlus) async {
    final existingItemResponse = await Supabase.instance.client
          .from('mcart')
          .select()
          .eq('cart_id', cartIdPlus);
    int currentQuantity = existingItemResponse[0]['quantity'] as int;
    int max_capacity = 0;
    final check_avail;

    if (existingItemResponse[0]['product_type'] == 'dhotel') {
      check_avail = await Supabase.instance.client
        .from('dhotel')
        .select()
        .eq('DHotelID', existingItemResponse[0]['product_id']);
      max_capacity = check_avail[0]['MaxQuota'];
    } else if (existingItemResponse[0]['product_type'] == 'mdestinations') {
      check_avail = await Supabase.instance.client
        .from('mdestinations')
        .select()
        .eq('id', existingItemResponse[0]['product_id']);
      max_capacity = check_avail[0]['MaxQuota'];
    } else if (existingItemResponse[0]['product_type'] == 'mtour') {
      check_avail = await Supabase.instance.client
        .from('mtour')
        .select()
        .eq('TourID', existingItemResponse[0]['product_id']);
      max_capacity = check_avail[0]['MaxQuota'];
    }

    if (currentQuantity < max_capacity) {
      final response = await Supabase.instance.client
        .from('mcart')
        .update({
          'quantity': currentQuantity + 1
        })
        .eq('cart_id', cartIdPlus);
      setState(() {
        items.forEach((item) {
          if (item.id == cartIdPlus) item.quantity++;
          if (item.quantity > max_capacity) item.quantity = max_capacity;
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            msg: 'Check your cart!',
            msg_detail: "You've reached the maximum stock.",
          );
        },
      );
    }
  }

  Future changeSelected(cartIdSelected) async {

    final existingItemResponse = await Supabase.instance.client
      .from('mcart')
      .select()
      .eq('cart_id', cartIdSelected);
    int currentStatus = existingItemResponse[0]['is_selected'] as int;
    int currentQuantity = existingItemResponse[0]['quantity'] as int;
    int max_capacity = 0;
    final check_avail;

    if (existingItemResponse[0]['product_type'] == 'dhotel') {
      check_avail = await Supabase.instance.client
        .from('dhotel')
        .select()
        .eq('DHotelID', existingItemResponse[0]['product_id']);
      max_capacity = check_avail[0]['MaxQuota'];
    } else if (existingItemResponse[0]['product_type'] == 'mdestinations') {
      check_avail = await Supabase.instance.client
        .from('mdestinations')
        .select()
        .eq('id', existingItemResponse[0]['product_id']);
      max_capacity = check_avail[0]['MaxQuota'];
    } else if (existingItemResponse[0]['product_type'] == 'mtour') {
      check_avail = await Supabase.instance.client
        .from('mtour')
        .select()
        .eq('TourID', existingItemResponse[0]['product_id']);
      max_capacity = check_avail[0]['MaxQuota'];
    }

    if (currentQuantity <= max_capacity) {
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
    } else {
      if (max_capacity == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              msg: 'Check your cart!',
              msg_detail: 'Item out of stock.',
            );
          },
        );
      } else if (max_capacity > 0 && currentQuantity > max_capacity) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              msg: 'Check your cart!',
              msg_detail: "You've exceeded the maximum stock.",
            );
          },
        );
      }
    }
  }

  List<CheckoutItem> convertToCheckoutItems(List<Map<String, dynamic>> list) {
  return list.map((item) {
    return CheckoutItem(
      productId: item['product_id'] as int,
      productName: item['product_name'] as String,
      productQty: item['product_qty'] as int,
      productPrice: item['product_price'] as int,
      productSubtotal: item['product_subtotal'] as int,
      productImg: item['product_img'] as String,
    );
  }).toList();
}

  Future checkoutItem() async {
    bool is_ok = false;
    List<Map<String, dynamic>> coList = [];
    print('Item Checkout:');

    var response = await Supabase.instance.client
      .from('mcart')
      .select('*')
      .eq('user_id', widget.username)
      .order('cart_id', ascending: true);
      
    // for (var x in response) {
    //   print(x);
    // }

    for (var x in response) {
      if (x['is_selected'] == 1) {
        int id = x['cart_id'];
        int qty = x['quantity'];
        int status = x['is_selected'];

        int max_capacity = 0;
        String name = '';
        int price = 0;
        String img = 'https://via.placeholder.com/150';
        final check_avail;

        if (x['product_type'] == 'dhotel') {
          check_avail = await Supabase.instance.client
            .from('dhotel')
            .select()
            .eq('DHotelID', x['product_id']);
          max_capacity = check_avail[0]['MaxQuota'];
          var responseMH = await Supabase.instance.client
            .from('mhotel')
            .select()
            .eq('HotelID', check_avail[0]['HotelID']);
          name = responseMH[0]['NamaHotel'] + '-' + check_avail[0]['Tipe'];
          price = check_avail[0]['Harga'] as int;
          img = responseMH[0]['image_url'];
        } else if (x['product_type'] == 'mdestinations') {
          check_avail = await Supabase.instance.client
            .from('mdestinations')
            .select()
            .eq('id', x['product_id']);
          max_capacity = check_avail[0]['MaxQuota'];
          name = check_avail[0]['attraction_name'];
          price = check_avail[0]['Price'];
          img = check_avail[0]['image_url'];
        } else if (x['product_type'] == 'mtour') {
          check_avail = await Supabase.instance.client
            .from('mtour')
            .select()
            .eq('TourID', x['product_id']);
          max_capacity = check_avail[0]['MaxQuota'];
          name = check_avail[0]['NamaTour'];
          price = check_avail[0]['Price'];
          img = check_avail[0]['image_url'];
        }

        if (qty <= max_capacity) {
          is_ok = true;
          coList.add({'product_id': x['product_id'], 'product_name': name, 'product_qty': qty, 'product_price': price, 'product_subtotal': qty * price, 'product_img': img});
        } else {
          is_ok = false;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return WarningDialog(
                msg: 'Check your cart!',
                msg_detail: 'Some item may not available.',
              );
            },
          );
          check_avail_item();
          break;
        }
      }
    }

    for (var y in coList) {
      print(y);
    }

    if (is_ok == true) {
      print('Gas OKE');
      print('Total: ' + total.toString());

      List<CheckoutItem> checkoutItems = convertToCheckoutItems(coList);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Checkout(
            name: widget.name,
            username: widget.username,
            items: checkoutItems,
          )
        ),
      );
    }
    
  }

  Future check_avail_item() async {
    var response = await Supabase.instance.client
      .from('mcart')
      .select('*')
      .eq('user_id', widget.username)
      .order('cart_id', ascending: true);

    for (var product in response) {
      var id = product['cart_id'];
      String productType = product['product_type'];
      int qty = product['quantity'];

      int max_capacity = 0;
      final check_avail;

      if (productType == 'dhotel') {
        check_avail = await Supabase.instance.client
          .from('dhotel')
          .select()
          .eq('DHotelID', product['product_id']);
        max_capacity = check_avail[0]['MaxQuota'];
      } else if (productType == 'mdestinations') {
        check_avail = await Supabase.instance.client
          .from('mdestinations')
          .select()
          .eq('id', product['product_id']);
        max_capacity = check_avail[0]['MaxQuota'];
      } else if (productType == 'mtour') {
        check_avail = await Supabase.instance.client
          .from('mtour')
          .select()
          .eq('TourID', product['product_id']);
        max_capacity = check_avail[0]['MaxQuota'];
      }

      if (qty > max_capacity) {
        final response = await Supabase.instance.client
          .from('mcart')
          .update({
            'is_selected': 0
          })
          .eq('cart_id', id);
        
        // setState(() {
          
        // });
      }
    }
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
    fetchCartItems();
    // if (mounted) {
    //   Navigator.pop(context);
    // }
  }

  Future fetchCartItems() async {
    // check_avail_item();
    
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
        price = responseDH[0]['Harga'] as int;
        img = responseMH[0]['image_url'];
      } else if (productType == 'mdestinations') {
        var responseMD = await Supabase.instance.client
          .from('mdestinations')
          .select()
          .eq('id', product['product_id']);
        print(responseMD);
        name = responseMD[0]['attraction_name'];
        price = responseMD[0]['Price'] as int;
        img = responseMD[0]['image_url'];
      } else if (productType == 'mtour') {
        var responseMT = await Supabase.instance.client
          .from('mtour')
          .select()
          .eq('TourID', product['product_id']);
        print(responseMT);
        name = responseMT[0]['NamaTour'];
        price = responseMT[0]['Price'] as int;
        img = responseMT[0]['image_url'];
      }

      setState(() {
        items.add(Item(id: product['cart_id'], name: name, imageUrl: img, quantity: qty, price: price, isSelected: product['is_selected'] as int == 1 ? true : false));
      });
      // items.add(Item(name: name, imageUrl: img, quantity: qty, price: price, isSelected: product['is_selected'] as int == 1 ? true : false));
    }
    if (mounted) {
      Navigator.pop(context);
    }
    
  }

  @override
  void initState() {
    check_avail_item();
    // fetchCartItems();
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
                                  // item.isSelected = value!;
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
                                // setState(() {
                                //   item.quantity++;
                                // });
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