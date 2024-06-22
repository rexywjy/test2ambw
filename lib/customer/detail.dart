import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailPage(menuType: 'mdestinations', index: 1, id: "HotelID"),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String menuType;
  final int index;
  final String id;

  DetailPage({required this.menuType, required this.index, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var fetchedData;
  bool isLoading = true;

  Future<void> fetchTourData() async {
    final response = await Supabase.instance.client
        .from(widget.menuType)
        .select()
        .eq(widget.id, widget.index)
        .single();

    setState(() {
      fetchedData = response;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTourData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : widget.menuType == "mdestinations"
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(children: [
                        Container(
                          height: 125,
                          decoration: BoxDecoration(color: Color(0xFFFFA800)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 75, left: 10),
                          child: IconButton(
                            icon: FaIcon(FontAwesomeIcons.arrowLeft),
                            onPressed: () {
                              Navigator.pop(
                                  context); // Navigate back to previous page
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: MediaQuery.of(context).size.width / 2 - 65,
                          child: Text("DETAILS",
                              style: GoogleFonts.montserrat(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )
                      ]),
                      Container(
                        width: double.infinity,
                        height: 260,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(fetchedData['image_url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              fetchedData!['attraction_name'] ?? 'No Title',
                              style: GoogleFonts.montserrat(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              fetchedData!['alamat'] ?? 'No Location',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Rp. ${fetchedData!['price'] ?? 'No Price'}" +
                                  " / pax",
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Description",
                              style: GoogleFonts.montserrat(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFFA800).withOpacity(0.3),
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  fetchedData!['description'] ??
                                      'No Description',
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFA800),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Book Now',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : widget.menuType == "mhotel"
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: 125,
                              decoration:
                                  BoxDecoration(color: Color(0xFFFFA800)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 75, left: 10),
                              child: IconButton(
                                icon: FaIcon(FontAwesomeIcons.arrowLeft),
                                onPressed: () {
                                  Navigator.pop(
                                      context); // Navigate back to previous page
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: MediaQuery.of(context).size.width / 2 - 65,
                              child: Text("DETAILS",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )
                          ]),
                          Container(
                            width: double.infinity,
                            height: 260,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(fetchedData['image_url']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  fetchedData!['NamaHotel'] ?? 'No Title',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  fetchedData!['LokasiHotel'] ?? 'No Location',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Rp. 1.000.000" + " / pax",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 20),
                                //Placeholder List Kamar
                                Column(children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFA800),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                                ]),
                                SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFFFA800),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      'Book Now',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : widget.menuType == "mtour"
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(children: [
                                Container(
                                  height: 125,
                                  decoration:
                                      BoxDecoration(color: Color(0xFFFFA800)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 75, left: 10),
                                  child: IconButton(
                                    icon: FaIcon(FontAwesomeIcons.arrowLeft),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Navigate back to previous page
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: MediaQuery.of(context).size.width / 2 -
                                      65,
                                  child: Text("DETAILS",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                )
                              ]),
                              Container(
                                width: double.infinity,
                                height: 260,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(fetchedData['image_url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: fetchedData![
                                                    'DepartureLocation'] +
                                                " ",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const WidgetSpan(
                                            child: FaIcon(
                                              FontAwesomeIcons.plane,
                                              size: 26,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " " +
                                                fetchedData![
                                                    'DestinationLocation'],
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Return Trip",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      convertToIdr(fetchedData!["Price"], 0) +
                                          " / pax",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Description",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Max Quota: " +
                                              fetchedData!['MaxQuota']
                                                  .toString() ??
                                          'No Description',
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFFFA800),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Book Now',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
    );
  }

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}
