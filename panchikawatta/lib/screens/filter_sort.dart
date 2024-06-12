// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class FilterSortScreen extends StatefulWidget {
  @override
  _FilterSortScreenState createState() => _FilterSortScreenState();
}

class _FilterSortScreenState extends State<FilterSortScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter and Sort'),
      ),
      body: Center(
        child: Text(
          'Filter and Sort Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
