import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/screens/Order/order_successful_screen.dart';

class InfoScreen extends StatelessWidget {
  final int orderId;

  InfoScreen({required this.orderId});

  Future<void> finalizeOrder(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${Utils.baseUrl}/adListing/finalizeOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, int>{
        'orderId': orderId,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderPlacedSuccessfullyScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to finalize order'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Info', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Order Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Divider(),
              SizedBox(height: 20),
              Text('Order #$orderId', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text(
                'Cash on Delivery: You can pay in cash to our courier when your parcel is delivered to your doorstep.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Order Confirmation: Before making the payment, please confirm your order number, sender information, and tracking number on the parcel.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Delivery Times:\n -> Colombo & Suburbs: Within 3 days\n -> Other Areas: Within 7 days',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () => finalizeOrder(context),
                  child: Text('Proceed to Finalize', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
