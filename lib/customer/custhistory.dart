import "package:flutter/material.dart";

class CustHistory extends StatefulWidget {
  const CustHistory({super.key});

  @override
  State<CustHistory> createState() => _CustHistoryState();
}

class _CustHistoryState extends State<CustHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: const Center(
        child: Text("History"),
      ),

    );
  }
}