import 'package:flutter/material.dart';

class DropdownInputField extends StatefulWidget {
  final List<String> dropdownItems;
  final String hintText;
  final String? initialValue;

  DropdownInputField({
    required this.dropdownItems,
    required this.hintText,
    required this.initialValue,
  });

  @override
  _DropdownInputFieldState createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    // if (widget.dropdownItems.isNotEmpty) {
      _dropdownValue = widget.dropdownItems[0];
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DropdownButtonFormField<String>(
        value: _dropdownValue,
        hint: Text(widget.hintText),
        items: widget.dropdownItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 16, color: Color(0xCC000000), fontWeight: FontWeight.normal),
              child: Text(value),
            )
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _dropdownValue = newValue;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none, 
        ),
      ),
    );
  }
}