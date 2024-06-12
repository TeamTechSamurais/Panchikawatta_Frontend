// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class Fuel extends StatefulWidget {
  final String? selectedFuel;
  final List<String> fuel;
  final void Function(String?) onChanged;

  // ignore: use_super_parameters
  const Fuel({
    Key? key,
    required this.selectedFuel,
    required this.fuel,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FuelState createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedFuel,
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
      items: widget.fuel.map((fuel) {
        return DropdownMenuItem<String>(
          value: fuel,
          child: Text(fuel),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
