import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:test2ambw/customer/login.dart';
import 'package:test2ambw/customer/cart/success_dialog.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: DetailPage(menuType: 'mdestinations', index: 1, id: "HotelID"),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String menuType;
  final int index;
  final String id;

  final String username;

  DetailPage({required this.menuType, required this.index, required this.id, required this.username});

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

    if (widget.menuType == "mhotel") {
      final response = await Supabase.instance.client
          .from(widget.menuType)
          .select('*, dhotel(*)');
    }

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

  Future<void> addToCart() async {
    var user_id = widget.username;
    var product_type = widget.menuType == 'mhotel' ? 'dhotel' : widget.menuType;
    var product_id = widget.index;

    print(user_id);

    try {
      final existingItemResponse = await Supabase.instance.client
          .from('mcart')
          .select()
          .eq('user_id', user_id)
          .eq('product_type', product_type)
          .eq('product_id', product_id);
      if (existingItemResponse != null && existingItemResponse.isNotEmpty) {
        int currentQuantity = existingItemResponse[0]['quantity'] as int;
        final response = await Supabase.instance.client
            .from('mcart')
            .update({
              'quantity': currentQuantity + 1,
              'is_selected': 1,
            })
            .eq('user_id', user_id)
            .eq('product_type', product_type)
            .eq('product_id', product_id);

        print('Quantity incremented successfully: $response');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessDialog(
              msg: 'Add to Cart',
              msg_detail: 'Product quantity incremented in your cart.',
            );
          },
        );
      } else {
        final response = await Supabase.instance.client
            .from('mcart')
            .insert({
              'user_id': user_id,
              'product_type': product_type,
              'product_id': product_id,
              'quantity': 1,
              'is_selected': 1,
            })
            .select();

        if (response != null && response.isNotEmpty) {
          print('Data inserted successfully: $response');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                msg: 'Add to Cart',
                msg_detail: 'Product successfully added to your cart.',
              );
            },
          );
        } else {
          print('No data returned after insertion.');
        }
      }
    } catch (e) {
      print('Error adding item to database: $e');
    }
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with 20% opacity
                              spreadRadius: 2, // How much the shadow spreads
                              blurRadius: 7, // The blur radius of the shadow
                              offset: Offset(
                                  0, 3), // The position of the shadow (x, y)
                            ),
                          ],
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                height: 0.1,
                                thickness: 2,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.locationPin,
                                    color: Color(0xFFFFA800),
                                  ),
                                ),
                                Text(
                                  fetchedData!['alamat'] ?? 'No Location',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: FaIcon(FontAwesomeIcons.clock,
                                      color: Color(0xFFFFA800), size: 20),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: "Open",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " | Sun - Sat, 09:00 - 21.00",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(
                              height: 0.1,
                              thickness: 2,
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
                            SizedBox(height: 100),
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.2), // Shadow color with 20% opacity
                                  spreadRadius:
                                      2, // How much the shadow spreads
                                  blurRadius:
                                      7, // The blur radius of the shadow
                                  offset: Offset(0,
                                      3), // The position of the shadow (x, y)
                                ),
                              ],
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
                                  fetchedData!['NamaHotel'] ?? 'No Name',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.solidStar,
                                        color: Color(0xFFFFA800)),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0, top: 2),
                                      child: Text(
                                        fetchedData!['RatingHotel'].toString() +
                                                " Good" ??
                                            'No Rating',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFFA800)),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    height: 0.1,
                                    thickness: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.locationPin,
                                        color: Color(0xFFFFA800),
                                      ),
                                    ),
                                    Text(
                                      fetchedData!['LokasiHotel'] ??
                                          'No Location',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: FaIcon(
                                          FontAwesomeIcons.bellConcierge,
                                          color: Color(0xFFFFA800),
                                          size: 20),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                "Breakfast Included, Pool, Bar",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Divider(
                                  height: 0.1,
                                  thickness: 2,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Description",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFA800).withOpacity(0.3),
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.2), // Shadow color with 20% opacity
                                      spreadRadius:
                                          2, // How much the shadow spreads
                                      blurRadius:
                                          7, // The blur radius of the shadow
                                      offset: Offset(0,
                                          3), // The position of the shadow (x, y)
                                    ),
                                  ],
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
                                            text: fetchedData[
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
                                            text: ' ' +
                                                fetchedData[
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Divider(
                                        height: 0.1,
                                        thickness: 2,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: FaIcon(
                                            FontAwesomeIcons.calendar,
                                            color: Color(0xFFFFA800),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd MMMM yyyy').format(
                                                      DateTime.parse(
                                                          fetchedData![
                                                              'StartDate'])) +
                                                  " - " +
                                                  DateFormat('dd MMMM yyyy')
                                                      .format(DateTime.parse(
                                                          fetchedData![
                                                              'EndDate'])) ??
                                              'No date',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: FaIcon(
                                              FontAwesomeIcons.peopleGroup,
                                              color: Color(0xFFFFA800),
                                              size: 20),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: "Max Quota | ",
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: fetchedData["MaxQuota"]
                                                            .toString() +
                                                        " People" ??
                                                    'No Quota',
                                                style: GoogleFonts.montserrat(
                                                    color: Color(0xFFFFA800),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                      height: 0.1,
                                      thickness: 2,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Description",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFFFFA800).withOpacity(0.3),
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Experience the ultimate return trip adventure with our meticulously crafted tour package, offering an unforgettable blend of exploration, relaxation, and culinary delights." ??
                                              'No Description',
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
      bottomSheet: fetchedData == null
          ? Container()
          : widget.menuType != 'mhotel'
              ? Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("The Best Price",
                                style: GoogleFonts.montserrat(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                            Text(
                              convertToIdr(fetchedData!["Price"], 0) + "/ pax",
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
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFA800),
                          ),
                          onPressed: () {
                            addToCart();
                          },
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
                )
              : SizedBox(),
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
