import 'package:flutter/material.dart';

// ignore: camel_case_types
class alert_page extends StatelessWidget {
  const alert_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Quick Help',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const Center(
        child: Text('Alert Page Content'),
      ),
    );
  }
}
