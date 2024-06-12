// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class Origin extends StatefulWidget {
  final String? selectedOrigin;
  final List<String> origin;
  final void Function(String?) onChanged;

  // ignore: use_super_parameters
  const Origin({
    Key? key,
    required this.selectedOrigin,
    required this.origin,
    required this.onChanged,
  }) : super(key: key);

  @override
  _OriginState createState() => _OriginState();
}

class _OriginState extends State<Origin> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedOrigin,
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
      items: widget.origin.map((origin) {
        return DropdownMenuItem<String>(
          value: origin,
          child: Text(origin),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
