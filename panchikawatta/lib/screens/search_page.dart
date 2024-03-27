import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/browse.dart';

 
class search_page extends StatelessWidget {
  const search_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => browse()),
            );
          },
        ),
        title: const Text(
          '',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const Center(
        child: Text('Search Page Content'),
      ),
    );
  }
}
