import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatefulWidget {


  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    // fetch transactions from the server
    _fetchTransactions();
  }

  //fetch transactions from the server
  void _fetchTransactions() async {
    // fetch transactions from the server
    final response = await http.get(Uri.parse(
        'http://192.168.9.104:8082/api/finance&economy/finance/getall'));
    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // parse the JSON response
      final transactions = jsonDecode(response.body) as List;
      // convert the list of maps to a list of Transaction objects
      final List<Transaction> loadedTransactions = [];
      for (var transaction in transactions) {
        loadedTransactions.add(Transaction(
            transaction['id'],
            transaction['name'],
            transaction['description'],
            transaction['amount'],
            DateTime.parse(transaction['date'])));
      }
      // update the state of the app
      setState(() {
        _transactions = loadedTransactions;
      });
    } else {
      // show an error message
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // display cards for each transaction
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return Card(
            // display the transaction details
            child: ListTile(
              title: Text(transaction.name),
              subtitle: Text(transaction.description),
              trailing: Text(transaction.amount.toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchTransactions,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Transaction {
  final int id;
  final String name;
  final String description;
  final String amount;
  final DateTime date;

  Transaction(this.id, this.name, this.description, this.amount, this.date);
}
