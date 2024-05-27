 import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/Registration_successs.dart';
import 'package:panchikawatta/screens/Vehicledetails1.dart';
import 'package:panchikawatta/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Vehicledetails2 extends StatefulWidget {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final String? selectedPhotoPath;

  Vehicledetails2({
    Key? key,
    required this.usernameController,
    required this.passwordController,
    required this.emailController,
    this.selectedPhotoPath,
  }) : super(key: key);

  @override
  _Vehicledetails2State createState() => _Vehicledetails2State();
}

class _Vehicledetails2State extends State<Vehicledetails2> {
  String? selectedPhotoPath;

  @override
  void initState() {
    super.initState();
    selectedPhotoPath = widget.selectedPhotoPath;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, String?>? data = ModalRoute.of(context)!.settings.arguments as Map<String, String?>?;
    String fname = data?['firstname'] ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Vehicle Details',
          style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28),
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
                    InputFields(hintText: 'Mileage', width1: 0.8),
                    const SizedBox(height: 20),
                    InputFields(
                      hintText: 'Avg distance per week',
                      width1: 0.8,
                    ),
                    const SizedBox(height: 20),
                    InputFields(
                      hintText: 'Last Service date',
                      width1: 0.8,
                    ),
                    const SizedBox(height: 20),
                    InputFields(
                      hintText: 'Battery Condition',
                      width1: 0.8,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ClipRRect(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Vehicledetails1(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 249, 248, 247),
                            ),
                          ),
                          child: Text(
                            "+ Add Vehicle",
                            style: TextStyle(
                              color: Color.fromARGB(255, 234, 137, 9),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Back',  
                        ),
                        CustomButton(
                          onPressed: signUp,
                          text: "Register",
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

  void signUp() async {
    String username = widget.usernameController.text;
    String password = widget.passwordController.text;
    String email = widget.emailController.text;

    User? user = await widget._auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      print("User is successfully created");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Registraion_success(),
        ),
      );
    } else {
      print("Some error happened");
    }
  }

  @override
  void dispose() {
    widget.usernameController.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }
}
