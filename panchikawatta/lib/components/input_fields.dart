  import 'package:flutter/material.dart';

class InputFields extends StatefulWidget {
  final String hintText;
  final double width1;
  final Icon? suffixIcon;
  final VoidCallback? onPressed; // Add onPressed parameter
  final TextEditingController? controller; // Add controller parameter

  InputFields({
    required this.hintText,
    required this.width1,
    this.suffixIcon,
    this.onPressed, 
    this.controller, 
  });

  @override
  _InputFieldsState createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields>{
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widget.width1,
      height: 55,
      child: TextField(
        controller: widget.controller, // Assign the provided controller to the TextField
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xCC000000), fontWeight: FontWeight.normal),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.suffixIcon != null ? IconButton(
            onPressed: () {
              // If onPressed callback is provided, call it
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },
            icon: widget.suffixIcon!,
          ) : null,
        ),
      ),
    );
  }
}
