// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/grid_block.dart';
import 'package:panchikawatta/screens/abs_light_action.dart';
import 'package:panchikawatta/screens/brake_light_action.dart';
import 'package:panchikawatta/screens/check_engine_action.dart';
import 'package:panchikawatta/screens/engine_temp_action.dart';
import 'package:panchikawatta/screens/oil_pressure_action.dart';
import 'package:panchikawatta/screens/power_steering_action.dart';
import 'package:panchikawatta/screens/seat_belt_action.dart';
import 'package:panchikawatta/screens/security_light_action.dart';
import 'package:panchikawatta/screens/tire_pressure_action.dart';
import 'package:panchikawatta/screens/washer_fluid_action.dart';

class alert_page extends StatelessWidget {
  const alert_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Quick Help',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 0, // Space between rows
          crossAxisSpacing: 1.0, // Space between columns
          childAspectRatio: 1.2, // Ratio of width to height
          children: <Widget>[
            GridBlock(
              //imagePath: 'assets/check_engine.jpg',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => check_engine_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/seat_belt.png',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => engine_temp_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/check_engine.jpg',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => oil_pressure_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/seat_belt.png',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => brake_light_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/check_engine.jpg',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => abs_light_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/seat_belt.png',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tire_pressure_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/check_engine.jpg',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => power_steering_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/seat_belt.png',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => washer_fluid_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/check_engine.jpg',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => seat_belt_action(
                            key: key,
                          )),
                );
              },
            ),
            GridBlock(
              //imagePath: 'assets/seat_belt.png',
              buttonText: 'Instructions',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => security_light_action(
                            key: key,
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
