import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/drop_down_input_fields.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/auth_functions.dart';
import 'dart:io';
import 'package:panchikawatta/screens/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  File? _image; //create a File object to store the image
  bool isLoading = true;
  bool isUpdating = false;
  String? profilePictureUrl;
  final formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _province = TextEditingController();
  String? email;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {

    setState(() {
      isLoading = true;
    });

    try {

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      email = prefs.getString('userEmail');

      if (email != null) {

        final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          if (doc['profile_picture'] != null) {
            profilePictureUrl = doc['profile_picture'] as String;
          } 
          // else {
          //   profilePictureUrl = null; // Provide a default value or handle it as needed
          // }
        }

        final user = await ApiServices.getUserByEmail(email!);
        
        setState(() {

          _firstName.text = user['firstName'] ?? '';
          _lastName.text = user['lastName'] ?? '';
          _userName.text = user['userName'] ?? '';
          _email.text = user['email'] ?? '';
          _phone.text = user['phoneNo'] ?? '';
          _district.text = user['district'] ?? '';
          _province.text = user['province'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
      ), 

      body: isLoading? Center(
        child: Container(
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF5C01),),
          )
        ),
      ) 
      
      : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Center(
              child: Container(
                height: 150,
                width: 160,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:  CircleAvatar(
                        radius: 80,
                        backgroundImage: _image != null 
                          ? FileImage(_image!) as ImageProvider<Object>
                          : profilePictureUrl != null
                            ? NetworkImage(profilePictureUrl!)
                            : null, 
                        child: _image == null && profilePictureUrl == null
                          ? const Icon(Icons.person, size: 80) 
                          : null,
                      ),
                    ),
                          
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.file_upload, color: Colors.black, size: 30),
                        onPressed: () async {
                          final selectedImage = await showDialog <File> (
                            context: context, 
                            builder: (BuildContext context) {
                              return ImagePickerPage();
                            },
                          );
                          setState(() {
                            _image = selectedImage;
                            if (_image == null) {
                              profilePictureUrl = null;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1,  // left
                0,                                        // top
                MediaQuery.of(context).size.width * 0.1,  // right
                0,                                        // bottom
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InputFields(
                            hintText: 'First Name', 
                            width1: 0.38,
                            validator: (value) {
                              if (value!.isEmpty) { 
                                _showFillMessage("Please enter your first name"); 
                              }
                              return null;
                            },
                            controller: _firstName,
                          ),

                          InputFields(
                            hintText: 'Last Name', 
                            width1: 0.38,
                            validator: (value) {
                              if (value!.isEmpty) { 
                                _showFillMessage("Please enter your last name"); 
                              }
                              return null;
                            },
                            controller: _lastName,
                          ),

                        ],
                      ),

                      const SizedBox(height: 15),

                      InputFields(
                        hintText: 'Username', 
                        width1: 0.8,
                        validator: (value) {
                          if (value!.isEmpty) { 
                            _showFillMessage("Please enter your Username"); 
                          }
                          return null;
                        },
                        controller: _userName,
                      ),

                      const SizedBox(height: 15),

                      InputFields(
                        validator: (value) {
                          String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';    //format: username@domain.extension.
                          RegExp emailRegex = RegExp(emailPattern);

                          if (value!.isEmpty) { 
                            _showFillMessage("Please enter your email address"); 
                          }

                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        hintText: 'Email', 
                        width1: 0.8,
                        controller: _email,
                      ),

                      const SizedBox(height: 15),

                      InputFields(
                        hintText: 'Phone no', 
                        width1: 0.8, 
                        controller: _phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _showFillMessage('Please enter a phone number');
                          }
                          // Check if the phone number is valid
                          final phoneRegExp = RegExp(r'^\d{10}$');
                          if (!phoneRegExp.hasMatch(value!)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),                            

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              color: const Color(0xFFFAFAFA), // to visualize the container
                              child: DropdownInputField(  // use the custom DropdownInputField widget
                                dropdownItems: ['Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle', 'Kilinochchi', 'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'],
                                hintText: 'District',
                                initialValue: _district.text,
                                validator: (value) {
                                  if (value!.isEmpty) { 
                                    _showFillMessage("Please enter your province"); 
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Flexible (
                            child: Container(
                              color: const Color(0xFFFAFAFA), // to visualize the container
                              child: DropdownInputField(  // use the custom DropdownInputField widget
                                dropdownItems: ['Central', 'Eastern', 'North Central', 'Northern', 'North Western', 'Sabaragamuwa', 'Southern', 'Uva', 'Western'],
                                hintText: 'Province',
                                initialValue: _province.text,
                                validator: (value) {
                                  if (value!.isEmpty) { 
                                    _showFillMessage("Please enter your province"); 
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                                
                        ],
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: () {
                          
                          if (formKey.currentState?.validate() ?? false) {

                            setState(() {
                              isUpdating = true;
                            });

                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Re-Authenticate', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Please re-enter your password to save changes'),

                                      const SizedBox(height: 20),

                                      InputFields(
                                        hintText: 'Password',
                                        width1: 0.8,
                                        controller: _password,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),

                                  actions: [
                                    CustomButton(
                                      onPressed: () {

                                        if (_password.text.isEmpty) {
                                          _showFillMessage('Please enter your password');
                                          return;
                                        }

                                        User? user = _auth.currentUser;

                                        if (user == null) {
                                          print("No user is currently signed in.");
                                          return;
                                        }

                                        AuthCredential credential = EmailAuthProvider.credential(email: email!, password: _password.text);
                                        user.reauthenticateWithCredential(credential);
                                        print("Reauthentication successful");
                                              
                                        submitForm();

                                        Navigator.of(context).pop();
                                      },
                                      text: 'Re-Authenticate',
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5C01),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isUpdating
                          ? const CircularProgressIndicator(color: Color(0xFFFAFAFA))
                          : const Text('Save Changes', style: TextStyle(fontSize: 16, color: Color(0xFFFAFAFA))),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() {
    // Continue with form submission
    updateUser(
      context, 
      _password.text,
      _image?.path, 
      _firstName.text, 
      _lastName.text, 
      _userName.text, 
      _email.text, 
      _phone.text, 
      _district.text, 
      _province.text
    );
  }

  //A function for showing alerts.
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
              child: const Text("OK", style: TextStyle(color: Color(0xFFFF5C01))),
            ),
          ],
        );
      },
    );
  }

}