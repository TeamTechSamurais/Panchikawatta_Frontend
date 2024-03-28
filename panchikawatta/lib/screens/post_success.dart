// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/profile_page.dart';

class PostSuccess extends StatelessWidget {
  // ignore: use_super_parameters
  const PostSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.all(30),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  size: 100, color: Color(0xFFFF5C01)),
              Text(
                'Ad Posted Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFFFF5C01),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
