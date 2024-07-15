// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';

// class VehicleMake extends StatefulWidget {
//   final String? selectedMake;
//   final Function(String?)? onChanged;

//   const VehicleMake({super.key, this.selectedMake, this.onChanged});

//   @override
//   _VehicleMakeState createState() => _VehicleMakeState();
// }

// class _VehicleMakeState extends State<VehicleMake> {
  
//   final List<String> _vehicleMakes = [
//     'Any',
//     'Toyota',
//     'Honda',
//     'Nissan',
//     'Suzuki',
//     'Hyundai',
//     'Mitsubishi',
//     'Mazda',
//     'Kia',
//     'BMW',
//     'Mercedes-Benz',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: widget.selectedMake,
//       hint: const Text('Make'),
//       items: _vehicleMakes.map((String make) {
//         return DropdownMenuItem<String>(
//           value: make,
//           child: Text(make),
//         );
//       }).toList(),
//       onChanged: widget.onChanged,
//       isExpanded: true,
//     );
//   }
  
// }
import 'package:flutter/material.dart';

class VehicleMake extends StatefulWidget {
  //final String? selectedType;
  final String? selectedMake;
  final List<String> makes;
  final Function(String?)? onChanged;

  const VehicleMake(
      {super.key,
  //    this.selectedType,
      required this.makes,
      this.onChanged,
      required this.selectedMake});

  @override
  _VehicleMakeState createState() => _VehicleMakeState();
}

class _VehicleMakeState extends State<VehicleMake> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedMake,
      hint: const Text('Make'),
      items: widget.makes.map((String make) {
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
  'Motorcycle': [
    'Any',
    'Honda bike',
    'Yamaha',
    'Suzuki bike',
    'Kawasaki',
    'Ducati'
  ],
  'Three-Wheeler': [
    'Any',
    'Bajaj Three-Wheeler',
    'TVS Three-Wheeler',
    'Piaggio'
  ],
  'Bus': ['Any', 'Ashok Leyland', 'Tata', 'Mercedes-Benz', 'Volvo', 'Eicher'],
  'Van': [
    'Any',
    'Toyota van',
    'Nissan van',
    'Mitsubishi van',
    'Suzuki van',
    'Honda van'
  ],
  'SUV': ['Any', 'Toyota SUV', 'Honda SUV', 'Nissan SUV', 'Kia SUV'],
};