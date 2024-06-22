// import 'package:flutter/material.dart';

// class HomeSeller extends StatelessWidget {
//   const HomeSeller({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: 'Lexend'),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Home Seller'),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context); // This will navigate back to the previous screen
//             },
//           ),
//         ),
//         body: Center(
//           child: Text('WOI SELLER!'),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test2ambw/customer/profile.dart';
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
  var namaStore = '';
  var idStore = -1;

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  Future<void> fetchName() async {
    try{
      var response = await supabase
          .from('mcustomer')
          .select()
          .eq('Email', FirebaseAuth.instance.currentUser!.email.toString())
          ;
      var idcustomer = response[0]['ID'];
      response = await supabase
          .from('mseller')
          .select()
          .eq('CustID', idcustomer)
          ;
      // debugPrint("RESPONSE : "+response.toString());
      setState(() {
        this.namaStore = response[0]['Name'];
        this.idStore = response[0]['ID'];
      });
    }catch(e){
      debugPrint("ERROR : "+e.toString());
    }
  }

// final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

// final Color mainAmber = HexColor('#FFBF00');

// class HomeSeller extends StatefulWidget {
//   HomeSeller({super.key});

//   var pageNow = 0;
//   @override
//   State<HomeSeller> createState() => _HomeSellerState();
// }

// class _HomeSellerState extends State<HomeSeller> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Lexend',
            scaffoldBackgroundColor: Color.fromARGB(255, 23, 26, 31)),
        home: Scaffold(
            appBar: AppBar(
              title: Text((namaStore),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: mainAmber,
              actions: [],
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // This will navigate back to the previous screen
                },
              ),
            ),
            body: Center(
              // child: Flex(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 16.0, // gap between adjacent chips
                    runSpacing: 16.0, // gap between lines
                    alignment: WrapAlignment.center,
                    // direction: (MediaQuery.of(context).size.width > 1000) ? Axis.horizontal : Axis.vertical,
                    // direction: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeSellerStateTour(idStore: idStore)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlueLight,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          child: SizedBox(
                              height: 120,
                              width: 120,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(),
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 30, top: 10),
                                      child: Transform.rotate(
                                        angle: 40 * 3.14 / 180,
                                        child: Icon(
                                          Icons.airplanemode_active,
                                          size: 100,
                                          color: mainBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Tours',
                                    style: TextStyle(
                                        fontSize: 30, fontWeight: FontWeight.bold),
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
                              MaterialPageRoute(builder: (context) => HomeSellerStateHotel(idStore: idStore)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlueLight,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          child: SizedBox(
                              height: 120,
                              width: 120,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(),
                                    width: double.infinity,
                                    clipBehavior: Clip.antiAlias,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 20),
                                      child: Transform.rotate(
                                        angle: 0,
                                        child: Icon(
                                          Icons.local_hotel,
                                          size: 100,
                                          color: mainBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Hotels',
                                    style: TextStyle(
                                        fontSize: 30, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          )
        );
  }
}