// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/adPost1.dart';
import 'package:panchikawatta/screens/servicePost.dart';

class AdType extends StatelessWidget {
  const AdType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Ad Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdPost1()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5C01),
                padding: const EdgeInsets.all(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Sparepart',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 100),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const ServicePost()),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFFFF5C01),
            //     padding: const EdgeInsets.all(40),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   child: const Text(
            //     'Services',
            //     style: TextStyle(fontSize: 30, color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
