import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/Order/buyer_order.dart';
import 'package:panchikawatta/screens/Order/wishlist.dart';

class BuyerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1, // left
                0, // top
                MediaQuery.of(context).size.width * 0.1, // right
                0, // bottom
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    CustomButton(
                      onPressed: () {
                        print('Navigating to wishlist');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WishlistScreen(userId: 1)),
                        );
                      },
                      text: 'Wishlist',
                    ),
                    CustomButton(
                      onPressed: () {
                        print('Navigating to BuyerOrderScreen');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuyerOrderScreen()),
                        );
                      },
                      text: 'Orders',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Divider(
                color: Color(0x80000000),
                thickness: 1,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1, // left
                0, // top
                MediaQuery.of(context).size.width * 0.1, // right
                0, // bottom
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'My Vehicles',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  CustomButton(
                      onPressed: () {
                        // Add your button press logic here
                      },
                      text: "Add Vehicle")
                ],
              ),
            ),

            // Container(
            //   //color: Colors.pink.shade100,
            //   height: 1000,
            //   child: VehicleDetails(),
            // ),

          ],
        ),
      ),
    );
  }
}
