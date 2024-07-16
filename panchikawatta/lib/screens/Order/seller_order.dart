import 'package:flutter/material.dart';
import 'package:panchikawatta/services/order_api_services.dart';

class SellerOrderScreen extends StatelessWidget {
  final int userId;

  SellerOrderScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Received'),
        backgroundColor: Color(0xFFFF5C01),
      ),
      body: FutureBuilder(
        future: ApiService.getSellerOrdersByUserId(userId),
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
                return OrderCard(order: order, userId: userId);
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

  OrderCard({required this.order, required this.userId});

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
            if (order['status'] == 'Processing')
              ElevatedButton(
                onPressed: () async {
                  await ApiService.markOrderAsDispatched(order['orderId'], userId);
                  // Implement logic to refresh the list
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

class OrderStatusStepper extends StatelessWidget {
  final String status;

  OrderStatusStepper({required this.status});

  @override
  Widget build(BuildContext context) {
    int currentStep;
    if (status == 'Processing') {
      currentStep = 0;
    } else if (status == 'Dispatched') {
      currentStep = 1;
    } else {
      currentStep = 2;
    }

    return Stepper(
      currentStep: currentStep,
      steps: [
        Step(
          title: Text('Processing'),
          content: Container(),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Dispatched'),
          content: Container(),
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Delivered'),
          content: Container(),
          isActive: currentStep >= 2,
          state: currentStep == 2 ? StepState.complete : StepState.indexed,
        ),
      ],
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Container();
      },
    );
  }
}
