import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';

class SellerOrderScreen extends StatefulWidget {
  final int sellerId;

  SellerOrderScreen({required this.sellerId});

  @override
  _SellerOrderScreenState createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(
      Uri.parse('${Utils.baseUrl}/orders/seller/${widget.sellerId}'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final response = await http.put(
      Uri.parse('${Utils.baseUrl}/orders/$orderId/status'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'status': status}),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureOrders = fetchOrders();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update order status'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Orders', style: TextStyle(color: Color(0xFFFF5C01))),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Order> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    title: Text('Order #${orders[index].id}'),
                    subtitle: Text('Status: ${orders[index].status}'),
                    trailing: DropdownButton<String>(
                      value: orders[index].status,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          updateOrderStatus(orders[index].id, newValue);
                        }
                      },
                      items: <String>['Pending', 'In Progress', 'Shipped', 'Delivered']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load orders'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Order {
  final int id;
  final String status;

  Order({required this.id, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
    );
  }
}
