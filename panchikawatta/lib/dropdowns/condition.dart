// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class Condition extends StatefulWidget {
  final String? selectedCondition;
  final List<String> condition;
  final void Function(String?) onChanged;

  // ignore: use_super_parameters
  const Condition({
    Key? key,
    required this.selectedCondition,
    required this.condition,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ConditionState createState() => _ConditionState();
}

class _ConditionState extends State<Condition> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedCondition,
      decoration: InputDecoration(
        labelText: 'All',
        filled: true,
        fillColor: const Color(0xFFEBEBEB),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFEBEBEB), width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFF5c01), width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      items: widget.condition.map((condition) {
        return DropdownMenuItem<String>(
          value: condition,
          child: Text(condition),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
