import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/adPost1.dart';

// ignore: camel_case_types
class profile_page extends StatelessWidget {
  const profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: CustomButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdPost1(key: UniqueKey())),
            );
          },
          text: 'Post Ad',
        ),
      ),
    );
  }
}
