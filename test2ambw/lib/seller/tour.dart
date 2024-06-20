import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
final Color mainBlueLight = Color.fromARGB(255, 124, 202, 217);

final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

final Color mainAmber = HexColor('#FFBF00');

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

class HomeSellerStateTour extends StatefulWidget {
  const HomeSellerStateTour({super.key, this.isNew = 0, this.hotelID = 0});

  final int isNew;
  final int hotelID;

  @override
  State<HomeSellerStateTour> createState() => _HomeSellerStateTourState();
}

class _HomeSellerStateTourState extends State<HomeSellerStateTour> {
  List<String> list = <String>['All', 'Active', 'Inactive'];
  var filterActive = "All";

  var mtour = [];
  var mhotel = [];
  var isInitial = 1;
  Future<dynamic> fetchTourData() async {
    if (filterActive == "All") {
      mtour = await Supabase.instance.client
          .from('mtour')
          .select("*, dtour(*)")
          .eq('IsDel', 0)
          .order('TourID', ascending: true);
    } else {
      mtour = await Supabase.instance.client
          .from('mtour')
          .select("*, dtour(*)")
          .eq('IsDel', 0)
          .eq('Status', ((filterActive == "Active") ? 1 : 0))
          .order('TourID', ascending: true);
    }

    setState(() {
      isInitial = 0;
    });
  }

  Future<void> pindahKeForm(BuildContext context,
      {tourID = 0, isNew = 0}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailScreenTour(tourID: tourID, isNew: isNew)),
    );
    fetchTourData();
  }

  @override
  Widget build(BuildContext context) {
    if (isInitial == 1) {
      fetchTourData();
    }
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 23, 26, 31),
        appBar: AppBar(
          title: const Text(("List Tour"),
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: mainAmber,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color.fromARGB(255, 23, 26, 31)),
                    Text("New Tour",
                        style:
                            TextStyle(color: Color.fromARGB(255, 23, 26, 31))),
                  ],
                ),
                onPressed: () {
                  pindahKeForm(context, isNew: 1);
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: 
          Column(children: [
            Column(
              children: [
                const SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("Filter",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                        DropdownMenu<String>(
                          textStyle: const TextStyle(color: Colors.white),
                          menuStyle: MenuStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 100, 100, 100))),
                          initialSelection: list.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              filterActive = value!;
                            });
                            fetchTourData();
                          },
                          dropdownMenuEntries:
                              list.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.amber),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(255, 50, 50, 50))),
                                value: value,
                                label: value);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                    // height: double.minPositive,
                    child: 
                    Column(
                      children: mtour.map((tour) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Card(
                            color: const Color.fromARGB(255, 49, 52, 57),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  pindahKeForm(context,
                                      tourID: tour["TourID"], isNew: 0);
                                },
                                title: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, right: 5),
                                              child: Icon(Icons.circle,
                                                  color: (tour["Status"] == 1)
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 10),
                                            ),
                                            Text(tour["NamaTour"],
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        Text(
                                            tour["DepartureLocation"] +
                                                "-" +
                                                tour["DestinationLocation"],
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 150, 150, 150))),
                                        Row(
                                          children: [
                                            const Icon(Icons.people,
                                                color: Colors.white, size: 15),
                                            Text(
                                                ' ' +
                                                    (tour["MaxQuota"] ?? 0)
                                                        .toString() +
                                                    "pax",
                                                style: TextStyle(color: mainAmber)),
                                            const Padding(
                                                padding: EdgeInsets.only(right: 10)),
                                            const Icon(Icons.sunny,
                                                color: Colors.white, size: 15),
                                            Text(
                                                ' ' +
                                                    (daysBetween(
                                                                DateTime.parse(
                                                                    (tour[
                                                                        "StartDate"])),
                                                                DateTime.parse(
                                                                    (tour[
                                                                        "EndDate"]))) +
                                                            1)
                                                        .toString() +
                                                    "day(s)",
                                                style: TextStyle(color: mainAmber)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const Spacer(), // use Spacer
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            'Rp ' +
                                                NumberFormat("#,###")
                                                    .format((tour['Price']))
                                                    .replaceAll(",", "."),
                                            style: TextStyle(
                                                color: mainAmber, fontSize: 20)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ],)
          ,
        )
      );
  }
}

class DetailScreenTour extends StatefulWidget {
  const DetailScreenTour({super.key, this.isNew = 0, this.tourID = 0});

  final int isNew;
  final int tourID;

  @override
  State<DetailScreenTour> createState() => _DetailScreenTourState();
}

class _DetailScreenTourState extends State<DetailScreenTour> {
  final Color mainBlue = const Color.fromARGB(255, 3, 174, 210);

  final Color mainYellow = const Color.fromARGB(255, 253, 222, 85);

  final Color mainAmber = HexColor('#FFBF00');

  var nameField = TextEditingController();
  var departureField = TextEditingController();
  var destinationField = TextEditingController();
  var startField = TextEditingController();
  var endField = TextEditingController();
  var priceField = TextEditingController();

  Future insertData() async {
    var namaTmp = nameField.text;
    var departureTmp = departureField.text;
    var destinationTmp = destinationField.text;
    var startTmp = DateFormat('yyyy-MM-dd').format(startDateInput);
    var endTmp = DateFormat('yyyy-MM-dd').format(endDateInput);
    var hargaTmp = priceField.text;
    try {
      debugPrint(endTmp);
      // String userId = Supabase.instance.client.auth.currentUser!.id;
      if (widget.isNew == 1) {
        final List<Map<String, dynamic>> data =
            await Supabase.instance.client.from('mtour').insert({
          'NamaTour': namaTmp,
          'DepartureLocation': departureTmp,
          'DestinationLocation': destinationTmp,
          'StartDate': startTmp,
          'EndDate': endTmp,
          'Price': int.parse(hargaTmp),
          'Status': ((isActive) ? 1 : 0)
        }).select();

        // for (int i = 0; i < namaRoomNew.length; i++) {
        //   await Supabase.instance.client.from('dhotel').insert([
        //     {
        //       'HotelID': data[0]['HotelID'],
        //       'Tipe': namaRoomNew[i],
        //       'Harga': hargaRoomNew[i]
        //     }
        //   ]);
        // }woi
      } else {
        await Supabase.instance.client.from('mtour').update({
          'NamaTour': namaTmp,
          'DepartureLocation': departureTmp,
          'DestinationLocation': destinationTmp,
          'StartDate': startTmp,
          'EndDate': endTmp,
          'Price': int.parse(hargaTmp),
          'Status': ((isActive) ? 1 : 0)
        }).eq('TourID', widget.tourID);

        // for (int i = 0; i < namaRoomNew.length; i++) {
        //   await Supabase.instance.client.from('dhotel').insert([
        //     {
        //       'TourID': widget.tourID,
        //       'Tipe': namaRoomNew[i],
        //       'Harga': hargaRoomNew[i]
        //     }
        //   ]);
        // }
      }
    } catch (e) {
      //print statment for identify insert error in if any , it will print the error in console
      print("Error while inserting Data: $e ");
    }
    Navigator.pop(context, 0);
  }

  Future deleteData() async {
    try {
      await Supabase.instance.client
          .from('mtour')
          .update({'IsDel': 1}).eq('TourID', widget.tourID);
    } catch (e) {
      //print statment for identify insert error in if any , it will print the error in console
      print("Error while inserting Data: $e ");
    }
    Navigator.pop(context, 0);
  }

  var isInitial = 1;
  var howManyDays = 1;
  var tourData = [];
  Future<dynamic> fetchTourData() async {
    tourData = await Supabase.instance.client
        .from('mtour')
        .select("*, dtour(*)")
        .eq("TourID", widget.tourID);
    // var dtourDataTmp = tourData[0]["dhotel"];
    // for (int i = 0; i < dtourDataTmp.length; i++) {
    //   namaRoom.add(dtourDataTmp[i]["Tipe"]);
    //   hargaRoom.add(dtourDataTmp[i]["Harga"]);
    // }

    setState(() {
      isInitial = 0;
      isActive = tourData[0]["Status"] == 1 ? true : false;
      startDateInput = DateTime.parse(tourData[0]["StartDate"]);
      endDateInput = DateTime.parse(tourData[0]["EndDate"]);
      howManyDays = (daysBetween(startDateInput, endDateInput) + 1);
    });

    nameField.text = tourData[0]["NamaTour"];
    departureField.text = tourData[0]["DepartureLocation"];
    destinationField.text = tourData[0]["DestinationLocation"];
    priceField.text = tourData[0]["Price"].toString();
  }

  // var namaRoom = ["Standard", "Deluxe", "Suite"];
  // var hargaRoom = [1000000, 1500000, 2000000];
  var namaRoom = [];
  var hargaRoom = [];
  var namaRoomNew = [];
  var hargaRoomNew = [];
  var namaRoomField = TextEditingController();
  var hargaRoomField = TextEditingController();
  var isActive = false;
  DateTime startDateInput = DateTime.now();
  DateTime endDateInput = DateTime.now();
  // void saveData() {
  @override
  Widget build(BuildContext context) {
    if (isInitial == 1 && widget.isNew == 0) {
      fetchTourData();
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 26, 31),
      appBar: AppBar(
        title: Wrap(children: [
          Text((((widget.isNew == 0) ? "Edit" : "Add") + " Tour  "),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Icon(Icons.airplanemode_active)
        ]),
        backgroundColor: mainAmber,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon((widget.isNew == 0) ? Icons.save : Icons.add,
                      color: const Color.fromARGB(255, 23, 26, 31)),
                  Text((widget.isNew == 0) ? "Save" : "Add",
                      style: const TextStyle(color: Color.fromARGB(255, 23, 26, 31))),
                ],
              ),
              onPressed: () {
                insertData();
              },
            ),
          ),
          if (widget.isNew == 0)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    Text("Delete", style: TextStyle(color: Colors.red)),
                  ],
                ),
                onPressed: () {
                  deleteData();
                },
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tour Name",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: nameField,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Trip to Singapore..'),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Departure Location",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: departureField,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Surabaya'),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Destination Location",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: destinationField,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Singapore'),
                        ),
                      ]),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Start Date",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 200, 200),
                                    fontSize: 15)),
                            ElevatedButton(
                              onPressed: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: startDateInput,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 10)),
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    startDateInput = selectedDate;
                                  });
                                }
                              },
                              child: Text(
                                "${startDateInput.year.toString()}-${startDateInput.month.toString().padLeft(2, '0')}-${startDateInput.day.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("End Date",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 200, 200, 200),
                                    fontSize: 15)),
                            ElevatedButton(
                              onPressed: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: endDateInput,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 10)),
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                );
                                if (selectedDate != null) {
                                  setState(() {
                                    endDateInput = selectedDate;
                                  });
                                }
                              },
                              child: Text(
                                "${endDateInput.year.toString()}-${endDateInput.month.toString().padLeft(2, '0')}-${endDateInput.day.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black87),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          controller: priceField,
                          decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: '12.000.000..'),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Active",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        // SwitchExample(isActive: isActive,),
                        SizedBox(
                          width: 75,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Switch(
                              // This bool value toggles the switch.
                              value: isActive,
                              activeColor: mainAmber,
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  isActive = value;
                                });
                              },
                            ),
                          ),
                        )
                      ]),
                ),
                const Divider(color: Colors.grey),
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                        width: double.infinity, // <-- Your width
                        height: 50, // <-- Your height
                        child: ElevatedButton(
                          onPressed: () {
                            namaRoomField.clear();
                            hargaRoomField.clear();
                            showModalBottomSheet(
                                context: context,
                                //backgroundColor: Colors.transparent,
                                useRootNavigator: true,
                                builder: (context) => Container(
                                    height: 500,
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: namaRoomField,
                                            decoration: const InputDecoration(
                                                hintText: 'Room Type Name'),
                                          ),
                                          TextField(
                                            controller: hargaRoomField,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: 'Price',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    namaRoom.add(
                                                        namaRoomField.text);
                                                    hargaRoom.add(int.parse(
                                                        hargaRoomField.text));
                                                    namaRoomNew.add(
                                                        namaRoomField.text);
                                                    hargaRoomNew.add(int.parse(
                                                        hargaRoomField.text));
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(mainAmber),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                ),
                                                child: const Text("Add Room Type"),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )));
                            // setState(() {
                            //   _selectedIndex = 0;
                            //   logged = ;
                            //   hivePassword.delete('password');
                            //   password = 0;
                            // });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(mainBlue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: const Text('Add Room Type',
                              style: TextStyle(fontSize: 20)),
                        ))),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: howManyDays,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Wrap(
                              children: [
                                const Text("Day ",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                Text((index + 1).toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white))
                              ],
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Container(
                                      child: Card(
                                        color: const Color.fromARGB(255, 49, 52, 57),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                              title: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(namaRoom[index],
                                                      style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                              const Spacer(), // use Spacer
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text('Rp 50.000.000',
                                                      style: TextStyle(
                                                          color: mainAmber,
                                                          fontSize: 20)),
                                                  const Text('/ night',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              150,
                                                              150,
                                                              150),
                                                          fontSize: 15))
                                                ],
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ));
                              }),
                        ],
                      );
                    }),
              ],
            )),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key, this.isActive = false});

  final isActive;

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    widget.isActive ? light = true : light = false;
    return SizedBox(
      width: 75,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          // This bool value toggles the switch.
          value: light,
          activeColor: mainAmber,
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              light = value;
            });
          },
        ),
      ),
    );
  }
}
