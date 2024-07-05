import 'package:flutter/material.dart';

class OriginDropdown extends StatelessWidget {
  final String? selectedOrigin;
  final ValueChanged<String?> onChanged;

  OriginDropdown({
    Key? key,
    required this.selectedOrigin,
    required this.onChanged,
  }) : super(key: key);

  final List<String> origins = [
    'Any',
    'Local',
    'Japan',
    'UK',
    'Germany',
    'USA',
    'India'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedOrigin,
      hint: const Text('Origin'),
      items: origins.map((String origin) {
        return DropdownMenuItem<String>(
          value: origin,
          child: Text(origin),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
