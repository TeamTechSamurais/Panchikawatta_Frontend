// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class VehicleDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height, // Set to your desired height
        child: ListView.builder(
          itemCount: 20, // Replace with your actual item count
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Vehicle $index'),
            );
          },
        ),
      ),
    );
  }
}
