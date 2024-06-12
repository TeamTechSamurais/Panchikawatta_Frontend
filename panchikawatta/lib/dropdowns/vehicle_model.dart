// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class VehicleModel extends StatefulWidget {
  final String? selectedModel;
  final List<String> models;
  final void Function(String?) onChanged;

  const VehicleModel({
    super.key,
    required this.selectedModel,
    required this.models,
    required this.onChanged,
  });

  @override
  _VehicleModelState createState() => _VehicleModelState();
}

class _VehicleModelState extends State<VehicleModel> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedModel,
      decoration: InputDecoration(
        labelText: 'Select',
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
      items: widget.models.map((model) {
        return DropdownMenuItem<String>(
          value: model,
          child: Text(model),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
