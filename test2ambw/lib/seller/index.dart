import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test2ambw/seller/hotel.dart';
import 'package:test2ambw/seller/tour.dart';

final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
final Color mainBlueLight = Color.fromARGB(255, 124, 202, 217);

final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

final Color mainAmber = HexColor('#FFBF00');

class HomeSeller extends StatefulWidget {
  HomeSeller({super.key});

  var pageNow = 0;
  @override
  State<HomeSeller> createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Lexend',
            scaffoldBackgroundColor: Color.fromARGB(255, 23, 26, 31)),
        home: Scaffold(
            appBar: AppBar(
              title: Text(("Admin"),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: mainAmber,
              actions: [],
            ),
            body: Center(
              child: Flex(
                direction: (MediaQuery.of(context).size.width > 1000) ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeSellerStateTour()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlueLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      child: SizedBox(
                          height: 270,
                          width: 270,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(),
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Transform.rotate(
                                    angle: 40 * 3.14 / 180,
                                    child: Icon(
                                      Icons.airplanemode_active,
                                      size: 300,
                                      color: mainBlue,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Tours',
                                style: TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeSellerStateHotel()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlueLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      child: SizedBox(
                          height: 270,
                          width: 270,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(),
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 30, top: 45),
                                  child: Transform.rotate(
                                    angle: 0,
                                    child: Icon(
                                      Icons.local_hotel,
                                      size: 240,
                                      color: mainBlue,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Hotels',
                                style: TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            )));
  }
}