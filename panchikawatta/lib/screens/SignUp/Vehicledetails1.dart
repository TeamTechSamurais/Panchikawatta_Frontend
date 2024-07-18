import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/dropdowns/vehicle_type.dart';
import 'package:panchikawatta/screens/SignUp/Vehicledetails2.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawatta/screens/auth_functions.dart';
import 'package:panchikawatta/screens/login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

class Vehicledetails1 extends StatefulWidget {
  final int userId;
  final int vehicleId;

  Vehicledetails1({required this.userId, this.vehicleId = 0});

  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<Vehicledetails1> {
  final ImagePicker _picker = ImagePicker();
  //String? selectedPhotoPath;
  String? selectedtype;
  String? selectedmake;
  String? selectedmodel;
  String? imagePath;
  String? downloadUrl;
  TextEditingController yearController = TextEditingController();
  TextEditingController licenceDateController = TextEditingController();
  TextEditingController insuranceDateController = TextEditingController();

  void _showFillMessage(String message, [String? emailError]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fill Required Field"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              if (emailError != null) Text(emailError),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadVehiclePhoto(String uid, String imagePath) async {
    try {
      File file = File(imagePath);

      // Upload the file to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('vehicle_pictures/$uid/${file.path.split('/').last}')
          .putFile(file);

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Vehicle photo uploaded successfully. Download URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      // Handle any errors that occur during the process
      print("Error uploading vehicle photo: $e");
      throw e; // Optionally rethrow the exception to handle it elsewhere if needed
    }
  }

  Future<void> _uploadFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });

      downloadUrl =
          await uploadVehiclePhoto(widget.userId.toString(), imagePath!);

      setState(() async {
        // Update the state variable with the downloadUrl
        downloadUrl = downloadUrl;

        downloadUrl =
            await uploadVehiclePhoto(widget.userId.toString(), imagePath!);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() async {
        imagePath = pickedFile.path;
        await uploadVehiclePhoto(widget.userId.toString(), imagePath!);
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: const Text(
            'Vehicle Details',
            style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28),
          ),
        ),
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
                    if (imagePath != null)
                      Positioned.fill(
                        child: Image.file(
                          File(imagePath!),
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
                          icon: Icon(Icons.file_upload,
                              color: Colors.black, size: 30),
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
                MediaQuery.of(context).size.width * 0.1,
                0,
                MediaQuery.of(context).size.width * 0.1,
                0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: VehicleType(
                            selectedType: selectedtype,
                            onChanged: (String? value) {
                              setState(() {
                                selectedtype = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedmake,
                            hint: Text('Make'),
                            onChanged: (String? value) {
                              setState(() {
                                selectedmake = value;
                              });
                            },
                            items: selectedtype != null &&
                                    vehicleTypeToMakes[selectedtype!] != null
                                ? vehicleTypeToMakes[selectedtype!]!
                                    .map((make) {
                                    return DropdownMenuItem<String>(
                                      value: make,
                                      child: Text(make),
                                    );
                                  }).toList()
                                : [],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedmodel,
                            hint: Text('Model'),
                            onChanged: (value) {
                              setState(() {
                                selectedmodel = value;
                              });
                            },
                            items: selectedmake != null &&
                                    vehicleMakeToModels[selectedmake!] != null
                                ? vehicleMakeToModels[selectedmake!]!
                                    .map((model) {
                                    return DropdownMenuItem<String>(
                                      value: model,
                                      child: Text(model),
                                    );
                                  }).toList()
                                : [],
                          ),
                        ),
                        InputFields(
                          controller: yearController,
                          hintText: 'year',
                          width1: 0.38,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Divider(
                        color: Colors.black,
                        thickness: 0.5,
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
                      controller: licenceDateController,
                      hintText: 'DD/MM/YY',
                      width1: 0.8,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () =>
                          _selectDate(context, licenceDateController),
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
                      controller: insuranceDateController,
                      hintText: 'DD/MM/YY',
                      width1: 0.8,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: () =>
                          _selectDate(context, insuranceDateController),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => login()),
                            );
                          },
                          text: 'Skip',
                        ),
                        CustomButton(
                          onPressed: () async {
                            if (yearController.text.isEmpty &&
                                selectedtype == null &&
                                selectedmake == null &&
                                selectedmodel == null &&
                                licenceDateController.text.isEmpty &&
                                insuranceDateController.text.isEmpty) {
                              _showFillMessage(
                                  "Please fill   field to save details");
                            } else {
                              Map<String, dynamic> userData = {
                                'userId': widget.userId,
                                'type': selectedtype,
                                'make': selectedmake,
                                'model': selectedmodel,
                                'year':
                                    int.tryParse(yearController.text.trim()) ??
                                        0,
                                'licenceDate':
                                    licenceDateController.text.trim(),
                                'insuranceDate':
                                    insuranceDateController.text.trim(),
                                'imageUrls': downloadUrl,
                              };

                              try {
                                var response = await http.post(
                                  Uri.parse('http://10.0.2.2:8000/users/cv'),
                                  headers: {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(userData),
                                );

                                if (response.statusCode == 201) {
                                  final responseData =
                                      jsonDecode(response.body);
                                  int vehicleId = responseData['vehicleId'];
                                  final userId = widget.userId;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Vehicledetails2(
                                        vehicleId: vehicleId,
                                        userId: userId,
                                        imagePath: imagePath,
                                      ),
                                    ),
                                  );
                                } else {
                                  _showFillMessage(
                                      "Error: ${response.statusCode}");
                                }
                              } catch (e) {
                                print('Error: $e');
                                _showFillMessage(
                                  'Error registering vehicle. Please try again later.',
                                );
                              }
                            }

                            if (imagePath != null) {
                              await uploadVehiclePhoto(
                                  widget.userId.toString(), imagePath!);
                            }
                          },
                          text: 'Save',
                        ),
                      ],
                    ),
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
