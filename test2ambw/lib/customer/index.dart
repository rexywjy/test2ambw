import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2ambw/customer/profile.dart';
import 'login.dart';

class HomeCustomer extends StatefulWidget {
  HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  final user = FirebaseAuth.instance.currentUser;

  int currentPageIndex = 0;

  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        // labelBehavior: labelBehavior,
        // selectedIndex: currentPageIndex,
        // onDestinationSelected: (int index) {
        //   setState(() {
        //     currentPageIndex = index;
        //   });
        // },
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.shopping_cart),
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        
      ),
      body: const <Widget>[
          Center(
            child: Text('Home'),
          ),
          Center(
            child: Text('Cart'),
          ),
          Center(
            child: CustProfile(),
          ),
        ][currentPageIndex],
    );
  }
}