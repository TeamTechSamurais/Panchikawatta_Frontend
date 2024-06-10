// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class GridBlock extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  GridBlock(
      {required this.imagePath,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
