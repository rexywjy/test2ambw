import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

const List<TabItem> items = [
  TabItem(icon: Icons.home, title: 'Home', key: 'Home'),
  TabItem(icon: Icons.tour, title: 'Tours', key: 'Tours'),
  TabItem(icon: Icons.hotel, title: 'Hotels', key: 'Hotels'),
  TabItem(icon: Icons.location_on, title: 'Destinations', key: 'Destinations'),
  TabItem(icon: Icons.person, title: 'Profile', key: 'Profile'),
];

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int visit = 0;
  double height = 20;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);
  @override
  Widget build(BuildContext context) {
    return BottomBarSalomon(
      items: items,
      color: Color(0xFFFFA800),
      backgroundColor: Colors.white,
      colorSelected: Colors.white,
      backgroundSelected: Color(0xFFFFA800),
      borderRadius: BorderRadius.circular(0),
      indexSelected: visit,
      onTap: (index) => setState(() {
        visit = index;
      }),
    );
  }
}
