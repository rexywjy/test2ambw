import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class CustHistory extends StatefulWidget {
  final String username;
  const CustHistory({
    super.key,
    required this.username,
  });

  @override
  State<CustHistory> createState() => _CustHistoryState();
}

final supabase = Supabase.instance.client;

class _CustHistoryState extends State<CustHistory> {
  late Future<List<dynamic>> futureTrx;

  Future<List<dynamic>> loadtrx() async {
    try {
      debugPrint('Username: ' + widget.username);

      final response = await supabase
          .from("mtransaction")
          .select()
          .eq('user_id', widget.username)
          ;

      debugPrint("Loaded transactions: " + response.toString());

      if (response == null || response.isEmpty) {
        debugPrint('No transactions found for user: ' + widget.username);
        return [];
      }

      // Verify the structure of the response
      if (response is List) {
        return response;
      } else {
        debugPrint('Unexpected response structure: ${response.runtimeType}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching transactions: ' + e.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    futureTrx = loadtrx();
  }

  String formatCurrency(num amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ');
    return formatCurrency.format(amount);
  }
  
  String formatDateTime(String dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    return DateFormat('dd MMMM yyyy, HH:mm:ss').format(parsedDateTime);
  }

  String formatTransactionID(int id) {
    return id.toString().padLeft(6, '0'); // Pads the ID with leading zeros to ensure it's at least 6 digits
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureTrx,
              builder: (context, snapshot) {
                debugPrint("Snapshot connectionState: ${snapshot.connectionState}");
                debugPrint("Snapshot data: ${snapshot.data}");
                debugPrint("Snapshot error: ${snapshot.error}");

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No transactions found.'),
                  );
                } else {
                  List<dynamic> trx = snapshot.data!;
                  return ListView.builder(
                    itemCount: trx.length,
                    itemBuilder: (context, index) {
                      var transaction = trx[index];
                      return Card(
                        child: ListTile(
                          title: Text("#TRX${formatTransactionID(transaction['transaction_id'])}"),
                          subtitle: Text(formatDateTime(transaction['transaction_time'])),
                          trailing: Text(formatCurrency(transaction['transaction_total'])),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}