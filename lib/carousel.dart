import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ScrollImageCarousel extends StatelessWidget {
  const ScrollImageCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<dynamic> fetchTourData() async {
      var resp = await Supabase.instance.client.from('tours').select();
      print(resp);
      return resp;
    }

    return FutureBuilder(
      future: fetchTourData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          final tour_datas = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 25),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Row(
                children: List.generate(tour_datas.length, (index) {
                  final tour = tour_datas[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 225,
                          height: 260,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(tour['image_url']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Container(
                          width: 225,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromRGBO(0, 0, 0, 1),
                                Color.fromRGBO(0, 0, 0, 0),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: tour['departure_location'] + " ",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const WidgetSpan(
                                      child: FaIcon(
                                        FontAwesomeIcons.plane,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ' + tour['destination_location'],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                convertToIdr(tour['price'], 2) + ' /pax',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(5),
                                    ),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                      const Size(0, 0),
                                    ),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xFFFFA800),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Details',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        } else {
          return Text('No data');
        }
      },
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
