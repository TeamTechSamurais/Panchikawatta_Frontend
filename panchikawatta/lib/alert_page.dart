import 'package:flutter/material.dart';

// ignore: camel_case_types
class alert_page extends StatelessWidget {
  const alert_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Page'),
      ),
      body: const Center(
        child: Text('Alert Page Content'),
      ),
    );
  }
}
