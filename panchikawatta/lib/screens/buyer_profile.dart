// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/profile_page.dart';
import 'package:panchikawatta/screens/reminders.dart';
import 'package:panchikawatta/screens/vehicle_details.dart';

class BuyerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Circular profile picture and name
            const CircleAvatar(
              radius: 70, // Adjust radius as needed
              backgroundImage: AssetImage('assets/images/profileImage.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Anne Fernando',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BuyerProfile()),
                    );
                  },
                  child: const Text('        Buyer',
                      style: TextStyle(fontSize: 18, color: Color(0xFFFF5C01))),
                ),
                Text('|'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: const Text('Seller        ',
                      style: TextStyle(fontSize: 18, color: Color(0xFF757575))),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1, // left
                0, // top
                MediaQuery.of(context).size.width * 0.1, // right
                0, // bottom
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CustomButton(
                    //   onPressed: () {
                    //     // Add your button press logic here
                    //   },
                    //   text: 'Wishlist',
                    // ),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReminderScreen()),
                        );
                      },
                      text: 'Reminders',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
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
                    text: "Add Vehicle",
                  ),
                ],
              ),
            ),

            SizedBox(
              //color: Colors.pink.shade100,
              height: 1000,
              child: VehicleDetails(),
            ),
          ],
        ),
      ),
    );
  }
}
