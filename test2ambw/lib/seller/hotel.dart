import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

final Color mainBlue = Color.fromARGB(255, 3, 174, 210);
final Color mainBlueLight = Color.fromARGB(255, 124, 202, 217);

final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

final Color mainAmber = HexColor('#FFBF00');

class HomeSellerStateHotel extends StatefulWidget {
  const HomeSellerStateHotel({super.key, this.isNew = 0, this.hotelID = 0});

  final int isNew;
  final int hotelID;

  @override
  State<HomeSellerStateHotel> createState() => _HomeSellerStateHotelState();
}

class _HomeSellerStateHotelState extends State<HomeSellerStateHotel> {
  List<String> list = <String>['All', 'Active', 'Inactive'];
  var filterActive = "All";

  var mhotel = [];
  var isInitial = 1;
  Future<dynamic> fetchTourData() async {
    if (filterActive == "All") {
      mhotel = await Supabase.instance.client
          .from('mhotel')
          .select("*, dhotel(*)")
          .eq('IsDel', 0)
          .order('HotelID', ascending: true);
    } else {
      mhotel = await Supabase.instance.client
          .from('mhotel')
          .select("*, dhotel(*)")
          .eq('IsDel', 0)
          .eq('Status', ((filterActive == "Active") ? 1 : 0))
          .order('HotelID', ascending: true);
    }

    setState(() {
      isInitial = 0;
    });

    debugPrint("HOWYEAAA");
  }

  Future<void> pindahKeForm(BuildContext context,
      {hotelID = 0, isNew = 0}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DetailScreenHotel(hotelID: hotelID, isNew: isNew)),
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
          title: Text(("List Hotel"),
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: mainAmber,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color.fromARGB(255, 23, 26, 31)),
                    Text("New Hotel",
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
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("Filter",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                        DropdownMenu<String>(
                          textStyle: TextStyle(color: Colors.white),
                          menuStyle: MenuStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 100, 100, 100))),
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
                                            Color.fromARGB(255, 50, 50, 50))),
                                value: value,
                                label: value);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    // height: double.minPositive,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mhotel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Container(
                                child: Card(
                                  color: Color.fromARGB(255, 49, 52, 57),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        onTap: () {
                                          pindahKeForm(context,
                                              hotelID: mhotel[index]["HotelID"],
                                              isNew: 0);
                                        },
                                        title: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15, right: 5),
                                                      child: Icon(Icons.circle,
                                                          color: (mhotel[index][
                                                                      "Status"] ==
                                                                  1)
                                                              ? Colors.green
                                                              : Colors.red,
                                                          size: 10),
                                                    ),
                                                    Text(
                                                        mhotel[index]
                                                            ["NamaHotel"],
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white)),
                                                  ],
                                                ),
                                                Text(mhotel[index]["LokasiHotel"],
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 150, 150, 150))),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.white,
                                                        size: 15),
                                                    Text(
                                                        ' ' +
                                                            (mhotel[index][
                                                                        "RatingHotel"] ??
                                                                    0)
                                                                .toString(),
                                                        style: TextStyle(
                                                            color: mainAmber)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Spacer(), // use Spacer
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    'Rp ' +
                                                        NumberFormat("#,###")
                                                            .format((mhotel[index]['dhotel']
                                                                        .length >
                                                                    0)
                                                                ? mhotel[index]['dhotel']
                                                                        .map((m) => m[
                                                                            'Harga'])
                                                                        .reduce((a,
                                                                                b) =>
                                                                            a +
                                                                            b) /
                                                                    mhotel[index]['dhotel']
                                                                        .length
                                                                : 0)
                                                            .replaceAll(",", "."),
                                                    style: TextStyle(
                                                        color: mainAmber,
                                                        fontSize: 20)),
                                                Text('/ night',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 150, 150, 150),
                                                        fontSize: 15)),
                                                Text(
                                                    mhotel[index]['dhotel']
                                                            .length
                                                            .toString() +
                                                        ' Room Type(s)',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 200, 200, 200),
                                                        fontSize: 16))
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ));
                        })),
              ],
            ),
          ),
        ));
  }
}

class DetailScreenHotel extends StatefulWidget {
  DetailScreenHotel({super.key, this.isNew = 0, this.hotelID = 0});

  final int isNew;
  final int hotelID;

  @override
  State<DetailScreenHotel> createState() => _DetailScreenHotelState();
}

class _DetailScreenHotelState extends State<DetailScreenHotel> {
  final Color mainBlue = Color.fromARGB(255, 3, 174, 210);

  final Color mainYellow = Color.fromARGB(255, 253, 222, 85);

  final Color mainAmber = HexColor('#FFBF00');

  var nameField = TextEditingController();
  var locationField = TextEditingController();
  var priceField = TextEditingController();

  Future insertData() async {
    var namaTmp = nameField.text;
    var lokasiTmp = locationField.text;
    var hargaTmp = priceField.text;
    try {
      // String userId = Supabase.instance.client.auth.currentUser!.id;
      if (widget.isNew == 1) {
        final List<Map<String, dynamic>> data = await Supabase.instance.client
            .from('mhotel')
            .insert({
          'NamaHotel': namaTmp,
          'LokasiHotel': lokasiTmp,
          'Status': ((isActive) ? 1 : 0)
        }).select();

        for (int i = 0; i < namaRoomNew.length; i++) {
          await Supabase.instance.client.from('dhotel').insert([
            {
              'HotelID': data[0]['HotelID'],
              'Tipe': namaRoomNew[i],
              'Harga': hargaRoomNew[i]
            }
          ]);
        }
      } else {
        await Supabase.instance.client.from('mhotel').update({
          'NamaHotel': namaTmp,
          'LokasiHotel': lokasiTmp,
          'Status': ((isActive) ? 1 : 0)
        }).eq('HotelID', widget.hotelID);

        for (int i = 0; i < namaRoomNew.length; i++) {
          await Supabase.instance.client.from('dhotel').insert([
            {
              'HotelID': widget.hotelID,
              'Tipe': namaRoomNew[i],
              'Harga': hargaRoomNew[i]
            }
          ]);
        }
        for (int i = 0; i < roomUpdated.length; i++) {
          await Supabase.instance.client.from('dhotel').update({
            'Tipe': roomUpdated[i]["Tipe"],
            'Harga': roomUpdated[i]["Harga"]
          }).eq('DHotelID', roomUpdated[i]["DHotelID"]);
        }
      }
      Navigator.pop(context, 0);
    } catch (e) {
      //print statment for identify insert error in if any , it will print the error in console
      print("Error while inserting Data: $e ");
    }
  }

  Future deleteData() async {
    try {
      await Supabase.instance.client
          .from('mhotel')
          .update({'IsDel': 1}).eq('HotelID', widget.hotelID);
    } catch (e) {
      //print statment for identify insert error in if any , it will print the error in console
      print("Error while inserting Data: $e ");
    }
    Navigator.pop(context, 0);
  }

  var isInitial = 1;
  var hotelData = [];
  Future<dynamic> fetchTourData() async {
    hotelData = await Supabase.instance.client
        .from('mhotel')
        .select("*, dhotel(*)")
        .eq("HotelID", widget.hotelID); // woi nda urut
    var dHotelDataTmp = hotelData[0]["dhotel"];
    for (int i = 0; i < dHotelDataTmp.length; i++) {
      namaRoom.add(dHotelDataTmp[i]["Tipe"]);
      hargaRoom.add(dHotelDataTmp[i]["Harga"]);
    }

    setState(() {
      isInitial = 0;
      isActive = hotelData[0]["Status"] == 1 ? true : false;
    });

    nameField.text = hotelData[0]["NamaHotel"];
    locationField.text = hotelData[0]["LokasiHotel"];
  }

  // var namaRoom = ["Standard", "Deluxe", "Suite"];
  // var hargaRoom = [1000000, 1500000, 2000000];
  var namaRoom = [];
  var hargaRoom = [];
  var namaRoomNew = [];
  var hargaRoomNew = [];
  var roomUpdated = [];
  var namaRoomField = TextEditingController();
  var hargaRoomField = TextEditingController();
  var isActive = false;

  // void saveData() {
  @override
  Widget build(BuildContext context) {
    if (isInitial == 1 && widget.isNew == 0) {
      fetchTourData();
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 26, 31),
      appBar: AppBar(
        title: Wrap(children: [
          Text((((widget.isNew == 0) ? "Edit" : "Add") + " Hotel  "),
              style: TextStyle(fontWeight: FontWeight.bold)),
          Icon(Icons.hotel)
        ]),
        backgroundColor: mainAmber,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon((widget.isNew == 0) ? Icons.save : Icons.add,
                      color: Color.fromARGB(255, 23, 26, 31)),
                  Text((widget.isNew == 0) ? "Save" : "Add",
                      style: TextStyle(color: Color.fromARGB(255, 23, 26, 31))),
                ],
              ),
              onPressed: () {
                insertData();
              },
            ),
          ),
          if (widget.isNew == 0)
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Wrap(
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
                        Text("Hotel Name",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          controller: nameField,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'JW Marriot..'),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Location",
                            style: TextStyle(
                                color: Color.fromARGB(255, 200, 200, 200),
                                fontSize: 15)),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          controller: locationField,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: 'Singapore..'),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Active",
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
                Divider(color: Colors.grey),
                Padding(
                    padding: EdgeInsets.only(top: 10),
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
                                            decoration: InputDecoration(
                                                hintText: 'Room Type Name'),
                                          ),
                                          TextField(
                                            controller: hargaRoomField,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Price',
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
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
                                                child: Text("Add Room Type"),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(mainAmber),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.black),
                                                ),
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
                          child: const Text('Add Room Type',
                              style: TextStyle(fontSize: 20)),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(mainBlue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Wrap(
                      children: [
                        Text(namaRoom.length.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text(" Room(s)",
                            style: TextStyle(fontSize: 20, color: Colors.white))
                      ],
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: namaRoom.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Container(
                            child: Card(
                              color: Color.fromARGB(255, 49, 52, 57),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                    onTap: () {
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
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Room Type Name'),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          hargaRoomField,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Price',
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              namaRoom[index] = (
                                                                  namaRoomField
                                                                      .text);
                                                              hargaRoom[index] = (int.parse(
                                                                  hargaRoomField
                                                                      .text));
                                                              roomUpdated.add({
                                                                "DHotelID": hotelData[0]
                                                                        ["dhotel"]
                                                                    [index]["DHotelID"],
                                                                "Tipe": namaRoomField.text,
                                                                "Harga": int.parse(hargaRoomField.text)
                                                              });
                                                              debugPrint(roomUpdated[0].toString());
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              "Save Room Type"),
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        mainAmber),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .black),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))); //woi disini
                                              namaRoomField.text = namaRoom[index];
                                              hargaRoomField.text =
                                                  hargaRoom[index].toString();
                                    },
                                    title: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(namaRoom[index],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        Spacer(), // use Spacer
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                'Rp ${NumberFormat("#,###").format(hargaRoom[index]).replaceAll(",", ".")}',
                                                style: TextStyle(
                                                    color: mainAmber,
                                                    fontSize: 20)),
                                            Text('/ night',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 150, 150, 150),
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