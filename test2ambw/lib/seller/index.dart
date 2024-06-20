import 'package:flutter/material.dart';

class HomeSeller extends StatelessWidget {
  const HomeSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Lexend'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Seller'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // This will navigate back to the previous screen
            },
          ),
        ),
        body: Center(
          child: Text('WOI SELLER!'),
        ),
      ),
    );
  }
}
