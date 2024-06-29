import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/screens/Registration_successs.dart';
import 'package:panchikawatta/screens/auth_functions.dart';
import 'package:panchikawatta/screens/login.dart';
import 'package:panchikawatta/screens/sign_up2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class EmailValidationResult {
  final bool isValid;
  final String message;

  EmailValidationResult(this.isValid, this.message);
}

class PhoneNumberValidationResult {
  final bool isValid;
  final String message;

  PhoneNumberValidationResult(this.isValid, this.message);
}

class sign_up1 extends StatefulWidget {
  @override
  _SignUp1State createState() => _SignUp1State();
}

class _SignUp1State extends State<sign_up1> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  String? imagePath;
  bool _isSigningUp = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  String? selectedProvince;
  String? selectedDistrict;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

  String? validatePassword(String value) {
    // Password must contain at least one uppercase letter, one lowercase letter, one digit, one special character, and have a minimum length of 5 characters
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*])(?=.{5,})';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      if (value.length < 5) {
        return 'Password must have a minimum length of 5 characters';
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Password must contain at least one digit';
      } else {
        return 'Password must contain at least one special character';
      }
    }
    return null; // Return null for valid passwords
  }

  Future<EmailValidationResult> isEmailValid(String email) async {
    try {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$') //r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'
          .hasMatch(email)) {
        return EmailValidationResult(false, 'Invalid email format');
      }

      return EmailValidationResult(true, 'Email is valid');
    } catch (e) {
      return EmailValidationResult(false, 'Error verifying email: $e');
    }
  }

  PhoneNumberValidationResult validatePhoneNumber(String value) {
    // Phone number must be exactly 10 digits
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return PhoneNumberValidationResult(
          false, 'Phone number must be exactly 10 digits');
    }
    return PhoneNumberValidationResult(true, 'Phone number is valid');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
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
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 30),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[400],
                        child: ClipOval(
                          child: GestureDetector(
                            onTap: () async {
                              final imagePicker = ImagePicker();
                              final XFile? pickedFile =
                                  await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  imagePath = pickedFile.path;
                                });
                              }
                            },
                            child: imagePath != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        FileImage(File(imagePath!)),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey[400],
                                    child: Image.asset(
                                      'lib/src/img/profile.png',
                                      height: 250,
                                      width: 250,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        right: -10,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Add your desired padding here
                          child: GestureDetector(
                            onTap: () async {
                              final imagePicker = ImagePicker();
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext builder) {
                                  return SafeArea(
                                    child: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new ListTile(
                                          leading: new Icon(Icons.camera),
                                          title: new Text('Take Photo'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final XFile? pickedFile =
                                                await imagePicker.pickImage(
                                              source: ImageSource.camera,
                                            );
                                            if (pickedFile != null) {
                                              setState(() {
                                                imagePath = pickedFile.path;
                                              });
                                            }
                                          },
                                        ),
                                        new ListTile(
                                          leading:
                                              new Icon(Icons.photo_library),
                                          title:
                                              new Text('Choose from Gallery'),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final XFile? pickedFile =
                                                await imagePicker.pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            if (pickedFile != null) {
                                              setState(() {
                                                imagePath = pickedFile.path;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              'lib/src/img/uploadicon.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.5, width: 40),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldContainer(
                        child: TextFormField(
                          controller: firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _showFillMessage("Please enter your first name");
                              return null;
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: "First Name",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFieldContainer(
                        child: TextFormField(
                          controller: lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _showFillMessage("Please enter your last name");
                              return null;
                            }
                            return null;
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: "Last Name",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _showFillMessage("Please enter a username");
                        return null;
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _showFillMessage("Please enter a password");
                        return null;
                      }
                      // Custom password validation
                      return validatePassword(value);
                    },
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _showFillMessage("Please enter an email");
                        return null;
                      }
                      if (!RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(value)) {
                        // Display error message for invalid email format
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: phoneNoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _showFillMessage("Please enter a phone number");
                        return null;
                      }
                      // Custom phone number validation
                      PhoneNumberValidationResult validationResult =
                          validatePhoneNumber(value);
                      if (!validationResult.isValid) {
                        // Display error message for invalid phone number
                        return validationResult.message;
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone (+94)",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: ' Province',
                          border: InputBorder.none, // Set the hint text here
                        ),
                        isExpanded: true,
                        value: selectedProvince, // Use the selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProvince =
                                newValue; // Update the selected province
                          });
                        },
                        items: <String>[
                          'Western',
                          'Central',
                          'Southern',
                          'Northern',
                          'Eastern',
                          'North Western',
                          'North Central',
                          'Uva',
                          'Sabaragamuwa',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _showFillMessage("Please select a province");
                            return null;
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: ' District',
                          border: InputBorder.none, // Set the hint text here
                        ),
                        isExpanded: true,
                        value: selectedDistrict, // Use the selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDistrict =
                                newValue; // Update the selected district
                          });
                        },
                        items: <String>[
                          'Colombo',
                          'Gampaha',
                          'Kalutara',
                          'Kandy',
                          'Matale',
                          'Nuwara Eliya',
                          'Galle',
                          'Matara',
                          'Hambantota',
                          'Jaffna',
                          'Killinochchi',
                          'Mannar',
                          'Vavuniya',
                          'Mulaitivu',
                          'Batticaloa',
                          'Ampara',
                          'Trincomalee',
                          'Kurunegala',
                          'Puttalam',
                          'Anuradhapura',
                          'Polonnaruwa',
                          'Badulla',
                          'Monaragala',
                          'Ratnapura',
                          'Kegalle'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _showFillMessage("Please select a district");
                            return null;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: size.width * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: TextButton(
                      onPressed: handleNextButtonPressed,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFF5C01)),
                      ),
                      child: _isSigningUp
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        "Already have an Account?",
                        style: TextStyle(
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFFFF5C01),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onEnter: (PointerEnterEvent event) {},
                        onExit: (PointerExitEvent) {},
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleNextButtonPressed() async {
    // Check if any field is empty
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNoController.text.isEmpty ||
        selectedProvince == null ||
        selectedDistrict == null) {
      _showFillMessage("Please fill all required fields");
    } else {
      // Check password validity
      String? passwordError = validatePassword(passwordController.text);
      if (passwordError != null) {
        _showFillMessage(passwordError);
      } else {
        // Perform email validation asynchronously
        EmailValidationResult result = await isEmailValid(emailController.text);
        if (!result.isValid) {
          // Show validation message if email is not valid
          _showFillMessage(result.message, 'Please enter a valid email');
        } else {
          // Custom phone number validation
          PhoneNumberValidationResult phoneValidationResult =
              validatePhoneNumber(phoneNoController.text);
          if (!phoneValidationResult.isValid) {
            // Show validation message if phone number is not valid
            _showFillMessage(phoneValidationResult.message,
                'Please enter a valid phone number');
          } else {
            // If all fields are filled and password is valid, call createAccount()
            setState(() {
              _isSigningUp = true;
            });

            UserCredential? userCredential = await createAccount(
              usernameController.text.trim(),
              passwordController.text,
              emailController.text.trim(),
              imagePath
            );

            setState(() {
              _isSigningUp = false;
            });

            if (userCredential != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Registraion_success())
              );

              //Call saveUserEmail() to store the email locally.
              saveUserEmail(emailController.text);
            } else {
              _showFillMessage('Account creation failed');
            }
          };
        }
      }
    }
  }
}


//Save the email locally
Future<void> saveUserEmail(String email) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userEmail', email);
}