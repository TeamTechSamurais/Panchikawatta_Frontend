import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/Vehicledetails2.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/screens/sign_up1.dart';
import 'package:panchikawatta/screens/sign_up2.dart';

class Vehicledetails1 extends StatefulWidget {
  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<Vehicledetails1> {
  final TextEditingController licenseRenewalDateController = TextEditingController();
  final TextEditingController insuranceRenewalDateController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? selectedPhotoPath; // Variable to store the selected photo path

  Future<void> _uploadFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedPhotoPath = pickedFile.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedPhotoPath = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String,String?>? data = ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;

    String fname = data?['firstname'] ?? '';
    String lname = data?['lastname'] ?? '';
    String username = data?['username'] ?? '';  
    String password = data?['password'] ?? '';
    String email = data?['email'] ?? '';
    String phoneno = data?['phoneno'] ?? '';
    String? district = data?['district'];
    String? province = data?['province'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Vehicle Details', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 200,
                child: Stack(
                  children: [
                    if (selectedPhotoPath != null)
                      Positioned.fill(
                        child: Image.file(
                          File(selectedPhotoPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Positioned.fill(
                        child: Image.asset(
                          'lib/src/img/vehicleDetails.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    Positioned(
                      bottom: -20,
                      right: -10,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(Icons.file_upload, color: Colors.black, size: 30),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Upload Options"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Upload from Gallery'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _uploadFromGallery();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Take a Photo'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _takePhoto();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1, // left
                0, // top
                MediaQuery.of(context).size.width * 0.1, // right
                0, // bottom
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputFields(hintText: 'Vehicle Name', width1: 0.5),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(hintText: 'Type', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                        InputFields(hintText: 'Make', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(hintText: 'Model', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                        InputFields(hintText: 'Year', width1: 0.38),
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
                    InputFields(
                      controller: licenseRenewalDateController,
                      hintText: 'DD/MM/YY',
                      width1: 0.8,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () => _selectDate(context, licenseRenewalDateController),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Vehicle insurance renewal date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    InputFields(
                      controller: insuranceRenewalDateController,
                      hintText: 'DD/MM/YY',
                      width1: 0.8,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () => _selectDate(context, insuranceRenewalDateController),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Vehicledetails2( selectedPhotoPath: selectedPhotoPath,
        usernameController: TextEditingController(),
        passwordController: TextEditingController(),
        emailController: TextEditingController(),
        ),
                                 settings: RouteSettings(
                                  arguments: {
                                  
                                       'firstname': firstNameController.text,
                                  
                                }),
                               ),
                            );
                            
                          },
                          text: 'Skip',
                        ),
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Vehicledetails2(selectedPhotoPath: selectedPhotoPath, 
        usernameController: TextEditingController(),
        passwordController: TextEditingController(),
        emailController: TextEditingController(),

        )),
                            );
                          },
                          text:fname,
                        ),
                      ],
                    ),// Input fields and other widgets...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
