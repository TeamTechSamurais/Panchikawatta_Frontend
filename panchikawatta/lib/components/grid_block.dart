// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class GridBlock extends StatelessWidget {
  //final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  GridBlock(
      {
      //required this.imagePath,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image.asset(
          //   imagePath,
          //   width: 100,
          //   height: 100,
          // ),
          SizedBox(
            width: 100,
            height: 100,
            child: Container(
              color: Colors.grey, // Placeholder color
              child: Center(
                child: Text(
                  'No Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(foregroundColor: Color(0xFFFF5C01)),
            child: Text(
              buttonText,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline,
                color: Color(0xFFFF5C01),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
