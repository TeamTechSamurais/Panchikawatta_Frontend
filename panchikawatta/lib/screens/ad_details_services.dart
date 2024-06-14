// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class AdDetailsServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Index Ad $index'),
            );
          },
        ),
      ),
    );
  }
}
