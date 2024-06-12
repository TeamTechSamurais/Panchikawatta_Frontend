// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class engine_temp_action extends StatelessWidget {
  const engine_temp_action({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Divider(thickness: 1.5),
                  SizedBox(height: 16),
                  Text(
                    'Engine Temperature Warning',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // Increased spacing between sections
            // Commented out the image block
            // Center(
            //   child: Image.asset(
            //     'assets/warning_lights/engine_temp.jpg',
            //     width: 200,
            //     height: 200,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Container(
                  color: Colors.grey, // Placeholder color
                  child: Center(
                    child: Text(
                      'Engine Temp Button',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'The engine is overheated\n\n'
              '1. Pull over safely\n'
              '2. Turn off engine and allow to cool.\n'
              '3. Check coolant levels when safe.\n'
              '4. Seek professional help if issue persists.',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
