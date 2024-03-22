import 'package:flutter/material.dart';
//import 'package:panchikawatta/screens/add_vehicle_details.dart';
import 'package:panchikawatta/screens/profile_page.dart';


void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}
