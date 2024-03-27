// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

// ignore: camel_case_types
class Add_Image extends StatelessWidget {
  final double size;
  final Color color;

  const Add_Image({
    Key? key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.add_box_outlined,
      size: size,
      color: color,
    );
  }
}
