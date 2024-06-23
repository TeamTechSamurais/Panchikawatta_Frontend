// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class VehicleMakesDropdown extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? selectedMake;

  const VehicleMakesDropdown({super.key, this.onChanged, this.selectedMake});

  @override
  _VehicleMakesDropdownState createState() => _VehicleMakesDropdownState();
}

class _VehicleMakesDropdownState extends State<VehicleMakesDropdown> {
  final List<String> _vehicleMakes = [
    'Toyota',
    'Honda',
    'Nissan',
    'Ford',
    'Chevrolet',
    'BMW',
    'Mercedes',
    'Audi',
    'Volkswagen',
    'Hyundai',
  ];

  String? _selectedMake;

  @override
  void initState() {
    super.initState();
    _selectedMake = widget.selectedMake;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedMake,
      hint: const Text('Select Vehicle Make'),
      items: _vehicleMakes.map((String make) {
        return DropdownMenuItem<String>(
          value: make,
          child: Text(make),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedMake = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
      isExpanded: true,
    );
  }
}
