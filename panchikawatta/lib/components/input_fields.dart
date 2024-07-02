import 'package:flutter/material.dart';

class InputFields extends StatefulWidget {
  final String hintText;
  final double width1;
  final Icon? suffixIcon;   //This is for give an icon when needed
  final FormFieldValidator<String>? validator;    //This is for do validations when needed
  final FocusNode? focusNode; //for the search functionality in the chat app
  final VoidCallback? onPressed; // Add onPressed parameter
  final TextEditingController? controller; // Add controller parameter
  bool? obscureText; // Add obscureText parameter
  

  InputFields({
    required this.hintText,
    required this.width1,
    this.suffixIcon,
    this.validator,
    this.focusNode,
    this.onPressed, 
    this.controller, 
    this.obscureText = false,
  });

  @override
  _InputFieldsState createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields>{
  
  String _textFieldValue = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widget.width1,
      height: 55,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            _textFieldValue = value;
          });
        },
        focusNode: widget.focusNode,
        controller: widget.controller, // Assign the provided controller to the TextField
        obscureText: widget.obscureText!, // Assign the provided obscureText value to the TextField
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xCC000000), fontWeight: FontWeight.normal),
          filled: true,
          fillColor: Color.fromARGB(255, 241, 239, 237),//0x80FF5C01
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.suffixIcon != null ? IconButton(
            onPressed: () {
              if (widget.onPressed != null) {   //dinithi
                widget.onPressed!();  //dinithi
              }                       //dinithi
            },                        //dinithi
            icon: widget.suffixIcon!, //shashini
          ) : null,
        ),
        validator: widget.validator,
      ),
    );
  }
}
