// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:panchikawatta/components/custom_button.dart';
// import 'package:panchikawatta/components/input_fields.dart';


// class AddVehicleDetails extends StatefulWidget {
//   @override
//   _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
// }

// class _AddVehicleDetailsState extends State<AddVehicleDetails> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
//           onPressed: () {
//             // Navigate to the add vehicle page
//           },
//         ),
//         title: const Text('Vehicle Details', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
//       ),
      
      
//       //body of the page
//       body: SingleChildScrollView(
//         child:Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 height: 150,
//                 width: 200,
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: Image.asset('lib/assets/vehicleDetails.jpeg', fit: BoxFit.cover,),
//                     ),
                    
//                     //A button to upload the vehicle image
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: IconButton(
//                         icon: const Icon(Icons.file_upload, color: Colors.black, size: 30),
//                         onPressed: () {
//                           // Navigate to the add vehicle page
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                 MediaQuery.of(context).size.width * 0.1,  // left
//                 0,                                        // top
//                 MediaQuery.of(context).size.width * 0.1,  // right
//                 0,                                        // bottom
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
                    
                    
//                     const SizedBox(height: 15),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InputFields(hintText: 'Type', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
//                         InputFields(hintText: 'Make', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
//                       ],
//                     ),

//                     const SizedBox(height: 15),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InputFields(hintText: 'Model', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
//                         InputFields(hintText: 'Year', width1: 0.38,),
//                       ],
//                     ),

//                     const SizedBox(height: 15),

//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.8,
//                       child: const Divider(
//                         color: Colors.black,
//                         thickness: 1,
//                       ),
//                     ),

//                     const SizedBox(height: 15),

//                     const Text(
//                       'License Renewal Date',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF000000),
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     InputFields(hintText: 'DD/MM/YY', width1: 0.8, suffixIcon: const Icon(Icons.calendar_today)),

//                     const SizedBox(height: 15),

//                     const Text(
//                       'Vehicle insurance renewal date',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF000000),
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     InputFields(hintText: 'DD/MM/YY', width1: 0.8, suffixIcon: const Icon(Icons.calendar_today)),

//                     const SizedBox(height: 40),
                    
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomButton(
//                           onPressed: () {
//                             // Add your button press logic here
//                           },
//                           text: 'Skip',
//                         ),
//                         CustomButton(
//                           onPressed: () {
//                             // Add your button press logic here
//                           },
//                           text: 'Next',
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Add other widgets below if needed
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';

class AddVehicleDetails extends StatefulWidget {
  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<AddVehicleDetails> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _licenseDateController = TextEditingController();
  final TextEditingController _insuranceDateController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>>? _userFuture;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

     Future<void> _fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email != null) {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      final user = await ApiServices.getUserByEmail(email);
      final userId = user['id'];

      setState(() {
        _userFuture = Future.value(user);
        _userId = userId;

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          if (doc['profile_picture'] != null) {
          //  profilePictureUrl = doc['profile_picture'];
          } else {
        //    profilePictureUrl = null;
          }

          if (userId != null) {
        //    _fetchSellerStatus(userId);
          }
        }
      });
    } else {
      // Handle the case where the email is not found
      return showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
              content: const Text('You do not have an account. Please sign up.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  Future<void> _fetchUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });

    if (_userId != null) {
      _fetchVehicleDetails(_userId!);
    } else {
      _fetchUser();
    }
  }

  Future<void> _fetchVehicleDetails(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/users/cv?userId=$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _typeController.text = data['type'];
        _makeController.text = data['make'];
        _modelController.text = data['model'];
        _yearController.text = data['year'].toString();
        _licenseDateController.text = data['licenseDate'];
        _insuranceDateController.text = data['insuranceDate'];
      });
    } else {
      // Handle error response
    }
  }

  Future<void> _saveVehicleDetails() async {
    final data = {
      'userId': _userId,
      'type': _typeController.text,
      'make': _makeController.text,
      'model': _modelController.text,
      'year': int.tryParse(_yearController.text),
      'licenseDate': _licenseDateController.text,
      'insuranceDate': _insuranceDateController.text,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/users/cv'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Handle successful response
    } else {
      // Handle error response
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Positioned.fill(
                      child: Image.asset('lib/assets/vehicleDetails.jpeg', fit: BoxFit.cover),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.file_upload, color: Colors.black, size: 30),
                        onPressed: () {
                          // Implement file upload functionality
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
                        InputFields(
                          hintText: 'Type',
                          width1: 0.38,
                          suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000)),
                          controller: _typeController,
                        ),
                        InputFields(
                          hintText: 'Make',
                          width1: 0.38,
                          suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000)),
                          controller: _makeController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(
                          hintText: 'Model',
                          width1: 0.38,
                          suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000)),
                          controller: _modelController,
                        ),
                        InputFields(
                          hintText: 'Year',
                          width1: 0.38,
                          controller: _yearController,
                        ),
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
                      hintText: 'DD/MM/YY',
                      width1: 0.8,
                      suffixIcon: const Icon(Icons.calendar_today),
                      controller: _licenseDateController,
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
                      hintText: 'DD/MM/YY',
                      width1: 0.8,
                      suffixIcon: const Icon(Icons.calendar_today),
                      controller: _insuranceDateController,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            // Handle Skip action
                          },
                          text: 'Skip',
                        ),
                        CustomButton(
                          onPressed: () {
                            _saveVehicleDetails();
                          },
                          text: 'Next',
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
