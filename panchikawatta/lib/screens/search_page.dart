// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
//import 'package:panchikawatta/screens/filter_sort.dart';
import 'package:panchikawatta/screens/wishlist.dart';

// ignore: camel_case_types
class search_page extends StatelessWidget {
  const search_page({Key? key});

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
          '',
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
                builder: (context) => WishlistScreen(),
              ),
            );
          },
          text: 'Filter and Sort',
        ),
      ),
    );
  }
}
