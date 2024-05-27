import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';



import 'package:http/http.dart' as http;
import 'package:panchikawatta/screens/Vehicledetails2.dart';
import 'package:panchikawatta/screens/login.dart';
import 'package:panchikawatta/screens/sign_up1.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/Vehicledetails1.dart';

class sign_up2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUp2State();
  }
}

class _SignUp2State extends State<sign_up2> {
  String? imagePath;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController Business_NameController = TextEditingController();
  final TextEditingController Business_AddressController = TextEditingController();
  final TextEditingController Business_contact_noController = TextEditingController();
  final TextEditingController Business_descriptionController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, String?>? data =
        ModalRoute.of(context)!.settings.arguments as Map<String,String?>?;
 
    String fname = data?['firstname'] ?? '';
    String lname = data?['lastname'] ?? '';
    String username = data?['username'] ?? '';  
    String password = data?['password'] ?? '';
    String email = data?['email'] ?? '';
    String phoneno = data?['phoneno'] ?? '';
    String? district = data?['district'];
    String? province = data?['province'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Fill your Profile",
                      style: TextStyle(
                        color: Color(0xFFFF5C01),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: Text(
                  "If you want to sell, fill this out",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              
              TextFieldContainer(
                child: TextField(
                  controller: Business_NameController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Business Name",
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  controller: Business_AddressController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Business Address",
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  controller: Business_contact_noController,
                  decoration: InputDecoration(
                    hintText: "Business contact no",
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  cursorColor: Colors.black,
                  controller: Business_descriptionController,
                  decoration: InputDecoration(
                    hintText: "Business description",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: size.width * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Vehicledetails1()),  
                          );
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 246, 111, 38),
                          ),
                        ),
                        child: Text(
                          "Skip",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: TextButton(
                        onPressed: () {
                         
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Vehicledetails1(), 
                                
                                settings: RouteSettings(
                                  arguments: {
                                  'Business_Name': Business_NameController.text,
                                  'Business_Address': Business_AddressController.text,
                                  'Business_contact_no': Business_contact_noController.text,
                                  'Business_contact_no': Business_descriptionController.text,
                                  'firstname': firstNameController.text,
                                 
                                }),
                              ),
                            );
                          
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFF5C01),
                          ),
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
