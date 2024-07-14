import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BrowseMoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.sentiment_satisfied,
              size: 100,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              "We're sure you can find the part you're looking for, let's try",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.orange),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                // Navigate to the browse page or perform any action
              },
              child: Text('Browse More'),
            ),
          ],
        ),
      ),
    );
  }
}
