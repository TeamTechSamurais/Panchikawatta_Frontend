// vehicle_make.dart
// ignore_for_file: library_private_types_in_public_api, unnecessary_const

import 'package:flutter/material.dart';

class VehicleMake extends StatefulWidget {
  final String? selectedMake;
  final List<String> makes;
  final void Function(String?) onChanged;

  // ignore: use_super_parameters
  const VehicleMake({
    Key? key,
    required this.selectedMake,
    required this.makes,
    required this.onChanged,
  }) : super(key: key);

  @override
  _VehicleMakeState createState() => _VehicleMakeState();
}

class _VehicleMakeState extends State<VehicleMake> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedMake,
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
      items: widget.makes.map((make) {
        return DropdownMenuItem<String>(
          value: make,
          child: Text(make),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
