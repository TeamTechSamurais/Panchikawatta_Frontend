import 'package:flutter/material.dart';

// ignore: camel_case_types
class search_page extends StatelessWidget {
  const search_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: const Center(
        child: Text('Search Page Content'),
      ),
    );
  }
}
