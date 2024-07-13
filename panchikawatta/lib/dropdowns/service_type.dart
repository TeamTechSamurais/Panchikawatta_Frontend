import 'package:flutter/material.dart';

class ServiceType extends StatefulWidget {
  final String? selectedService;
  final Function(String?)? onChanged;

  const ServiceType({super.key, this.selectedService, this.onChanged});

  @override
  _ServiceTypeState createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  final List<String> _serviceTypes = [
    'Any',
    'Indoor Services',
    'Engine Related Services',
    'Exterior Services',
    'Tire and Wheel Services',
    'Brake Services',
    'Electrical Services',
    'Transmission Services',
    'Suspension and Steering Services',
    'Exhaust System Services',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedService,
      hint: const Text('Service Type'),
      items: _serviceTypes.map((String type) {
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
