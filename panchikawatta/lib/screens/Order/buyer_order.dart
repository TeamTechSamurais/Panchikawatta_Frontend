import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panchikawatta/constant/utils.dart';

class BuyerOrderPage extends StatefulWidget {
  final int userId;

  BuyerOrderPage({required this.userId});

  @override
  _BuyerOrderPageState createState() => _BuyerOrderPageState();
}

class _BuyerOrderPageState extends State<BuyerOrderPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final response = await http.get(Uri.parse('${Utils.baseUrl}}/adListing/orders/buyer/${widget.userId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        orders = data.map((order) => Order.fromJson(order)).toList();
      });
    }
  }

  Future<void> _markAsDelivered(int orderId) async {
    final response = await http.put(Uri.parse('${Utils.baseUrl}}/adListing/order/deliver/$orderId'));
    if (response.statusCode == 200) {
      _fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Color(0xFFFF5C01),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Order ID: ${order.orderId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Spare Part: ${order.sparePartTitle}'),
                  Text('Status: ${order.status}'),
                ],
              ),
              trailing: order.status == 'Dispatched'
                  ? ElevatedButton(
                      onPressed: () => _markAsDelivered(order.orderId),
                      child: Text('Mark as Delivered'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5C01),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class Order {
  final int orderId;
  final String sparePartTitle;
  final String status;

  Order({required this.orderId, required this.sparePartTitle, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      sparePartTitle: json['sparePart']['title'],
      status: json['status'],
    );
  }
}
