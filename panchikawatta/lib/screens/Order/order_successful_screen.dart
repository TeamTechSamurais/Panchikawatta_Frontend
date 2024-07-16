import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/app.dart';
import 'package:panchikawatta/screens/search_page1.dart';

class OrderPlacedSuccessfullyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle_outline_rounded,
                size: 100, color: Color(0xFFFF5C01)),
            Text('Order Placed Successfully',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C01)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              child: Text('Leave', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
