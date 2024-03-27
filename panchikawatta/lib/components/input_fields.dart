// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class InputFields extends StatefulWidget {
  final String hintText;
  final double width1;

  const InputFields({super.key, required this.hintText, required this.width1});

  @override
  _InputFieldsState createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  // ignore: unused_field
  String _textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widget.width1,
      height: 55,
      child: TextField(
        onChanged: (value) {
          setState(() {
            _textFieldValue = value;
          });
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xCC000000),
              fontWeight: FontWeight.normal),
          filled: true,
          fillColor: const Color(0xFFEBEBEB),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
