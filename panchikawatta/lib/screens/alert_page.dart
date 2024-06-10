// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/grid_block.dart';

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
          crossAxisCount: 2, // Number of columns in the grid
          children: <Widget>[
            GridBlock(
              imagePath: 'assets/WarningLights/seat_belt.png',
              buttonText: 'Button 1',
              onPressed: () {
                // Action for button 1
              },
            ),
            GridBlock(
              imagePath: 'assets/WarningLights/check_engine.jpg',
              buttonText: 'Button 2',
              onPressed: () {
                // Action for button 2
              },
            ),
            // Add more GridBlock widgets as needed
          ],
        ),
      ),
    );
  }
}
