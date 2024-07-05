// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class VehicleMake extends StatefulWidget {
  final String? selectedMake;
  final String? selectedType;
  final Function(String?)? onChanged;

  const VehicleMake({
    super.key,
    this.selectedMake,
    this.selectedType,
    this.onChanged,
    String? vehicleType,
  });

  @override
  _VehicleMakeState createState() => _VehicleMakeState();
}

class _VehicleMakeState extends State<VehicleMake> {
  Map<String, List<String>> vehicleTypeToMakes = {
    'Any': ['Any'],
    'Car': [
      'Any',
      'Toyota',
      'Honda',
      'Nissan',
      'Suzuki',
      'Hyundai',
      'Mitsubishi',
      'Mazda',
      'Kia',
      'BMW',
      'Mercedes-Benz'
    ],
    'Motorcycle': ['Any', 'Honda', 'Yamaha', 'TVS', 'Hero', 'Bajaj'],
    'Three-Wheeler': [
      'Any',
      'Bajaj Three-Wheeler',
      'Piaggio',
      'TVS Three-Wheeler',
      'Mahindra'
    ],
    'Truck': [
      'Any',
      'Tata Truck',
      'Isuzu Truck',
      'Mitsubishi Fuso Truck',
      'Ashok Leyland Truck',
      'Eicher Truck'
    ],
    'Bus': [
      'Any',
      'Tata',
      'Isuzu',
      'Mitsubishi Fuso',
      'Ashok Leyland',
      'Eicher'
    ],
    'Van': [
      'Any',
      'Toyota van',
      'Nissan van',
      'Suzuki van',
      'Honda van',
      'Mazda van',
      'Mitsubishi van'
    ],
    'SUV': [
      'Any',
      'Toyota SUV',
      'Honda SUV',
      'Nissan SUV',
      'Kia SUV',
      'BMW SUV',
      'Suzuki SUV'
    ],
  };

  List<String> getMakesForType(String type) {
    return vehicleTypeToMakes[type] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<String> makes = getMakesForType(widget.selectedType ?? 'Any');

    return DropdownButton<String>(
      value: widget.selectedMake,
      hint: const Text('Make'),
      items: makes.map((String make) {
        return DropdownMenuItem<String>(
          value: make,
          child: Text(make),
        );
      }).toList(),
      onChanged: widget.onChanged,
      isExpanded: true,
    );
  }
}
