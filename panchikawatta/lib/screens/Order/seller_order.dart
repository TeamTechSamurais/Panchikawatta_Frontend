import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/Order/stepper.dart';
import 'package:panchikawatta/services/order_api_services.dart';

class SellerOrderScreen extends StatefulWidget {
  final int userId;

  SellerOrderScreen({required this.userId});

  @override
  _SellerOrderScreenState createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  late Future<List<Map<String, dynamic>>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = ApiService.getSellerOrdersByUserId(widget.userId);
  }

  void _refreshOrders() {
    setState(() {
      _futureOrders = ApiService.getSellerOrdersByUserId(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Received'),
        backgroundColor: Color(0xFFFF5C01),
      ),
      body: FutureBuilder(
        future: _futureOrders,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  order: order,
                  userId: widget.userId,
                  onStatusChanged: _refreshOrders,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final int userId;
  final VoidCallback onStatusChanged;

  OrderCard({required this.order, required this.userId, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['orderId']}'),
            Text('Title: ${order['sparePart']['title']}'),
            OrderStatusStepper(status: order['status']),
            if (order['status'] == 'Completed')
              ElevatedButton(
                onPressed: () async {
                  await ApiService.markOrderAsDispatched(order['orderId'], userId);
                  onStatusChanged();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF5C01)),
                child: Text('Mark as Dispatched'),
              ),
          ],
        ),
      ),
    );
  }
}
