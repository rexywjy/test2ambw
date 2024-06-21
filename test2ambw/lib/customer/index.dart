import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2ambw/customer/home.dart';
import 'package:test2ambw/customer/profile.dart';
import 'login.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeCustomer extends StatefulWidget {
  final int initialPageIndex;
  final String name;
  final String username;

  const HomeCustomer({
    super.key,
    this.initialPageIndex = 0,
    required this.name,
    required this.username,
  });

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  final user = FirebaseAuth.instance.currentUser;

  final Color mainAmber = HexColor('#FFBF00');

  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.onlyShowSelected;

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
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
        backgroundColor: mainAmber,
        indicatorColor: Colors.white,
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
      body: <Widget>[
        Center(
          child: MyHomePage(name: widget.name, username: widget.username),
        ),
        Center(
          child: Text('Cart'),
        ),
        Center(
          child: CustProfile(name: widget.name, username: widget.username),
        ),
      ][currentPageIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart_outlined),
      //       label: 'Cart',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person_outline),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: currentPageIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
