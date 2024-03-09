import 'package:flutter/material.dart';

// ignore: camel_case_types
class profile_page extends StatelessWidget {
  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}
