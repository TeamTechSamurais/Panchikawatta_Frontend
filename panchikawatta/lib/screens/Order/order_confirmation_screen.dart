import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/services/post_api_service.dart';
import 'order_successful_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final int orderId;

  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  // bool _isLoading = false;

  // void _confirmOrder() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     await PostApiService.confirmOrder(widget.orderId);
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const OrderSuccessfulScreen(),
  //       ),
  //     );
  //   } catch (error) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to confirm order: $error')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Place Order',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xffFF5C01),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const Text(
              'Cash On Delivery:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              '• You Can Pay In Cash To Our Courier When Your Parcel Is Delivered To Your Doorstep.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Confirmation:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              '• Before Making The Payment, Please Confirm Your Order Number, Sender Information, And Tracking Number On The Parcel.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 35),
            const Text(
              'Delivery Times:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              '-> Colombo & Suburbs: Within 3 Days\n-> Other Areas: Within 7 Days',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderSuccessfulScreen(ads: [],)),
                  );
                },  // Ensure button is disabled when loading
                text: 'Confirm Order',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
