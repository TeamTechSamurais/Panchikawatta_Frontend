 import 'package:flutter/material.dart';

class VehicleType extends StatefulWidget {
  final String? selectedType;
  final Function(String?)? onChanged;

  const VehicleType({super.key, this.selectedType, this.onChanged});

  @override
  _VehicleTypeState createState() => _VehicleTypeState();
}

class _VehicleTypeState extends State<VehicleType> {
  final List<String> _vehicleTypes = [
    'Any',
    'Car',
    'Motorcycle',
    'Three-Wheeler',
    'Bus',
    'Van',
    'SUV',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedType,
      hint: const Text('Type'),
      items: _vehicleTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: widget.onChanged,
      isExpanded: true,
    );
  }
}