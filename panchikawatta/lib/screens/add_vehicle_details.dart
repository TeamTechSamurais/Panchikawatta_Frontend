// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';


class AddVehicleDetails extends StatefulWidget {
  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<AddVehicleDetails> {
  // ignore: unused_field
  String _textFieldValue = '';

  Widget buildInputField(BuildContext context, String hintText, double width1, {Icon? suffixIcon}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width1,
      height: 55,
      child: TextField(
        onChanged: (value) {
          setState(() {
            _textFieldValue = value;
          });
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16, color: Color(0xCC000000), fontWeight: FontWeight.normal),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),//0x80FF5C01
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon != null ? IconButton(
            onPressed: () {
              // Handle icon tap (e.g., open a date picker)
            },
            icon: suffixIcon,
          ) : null,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            // Navigate to the add vehicle page
          },
        ),
        title: const Text('Vehicle Details', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
      ),
      body: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset('lib/assets/vehicleDetails.jpeg', fit: BoxFit.cover,),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.file_upload, color: Colors.black, size: 30),
                        onPressed: () {
                          // Navigate to the add vehicle page
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,  // left
                0,                                        // top
                MediaQuery.of(context).size.width * 0.1,  // right
                0,                                        // bottom
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputField(context, 'Vehicle Name', 0.8),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInputField(context, 'Type', 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                        buildInputField(context, 'Make', 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInputField(context, 'Model', 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                        buildInputField(context, 'Year', 0.38,),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'License Renewal Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildInputField(context, 'DD/MM/YY', 0.8, suffixIcon: const Icon(Icons.calendar_today)),

                    const SizedBox(height: 15),

                    const Text(
                      'Vehicle insurance renewal date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    buildInputField(context, 'DD/MM/YY', 0.8, suffixIcon: const Icon(Icons.calendar_today)),

                    const SizedBox(height: 40),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            // Add your button press logic here
                          },
                          text: 'Skip',
                        ),
                        CustomButton(
                          onPressed: () {
                            // Add your button press logic here
                          },
                          text: 'Next',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Add other widgets below if needed
          ],
        ),
      ),
    );
  }
}