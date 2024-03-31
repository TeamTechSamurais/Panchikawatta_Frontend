import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/drop_down_input_fields.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'dart:io';
import 'package:panchikawatta/screens/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  File? _image; //create a File object to store the image
  // final emailController = TextEditingController(); //create a TextEditingController for the email field
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            // Navigate to the add vehicle page
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
      ), 

      body:  SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Container(
                height: 150,
                width: 160,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:  CircleAvatar(
                        radius: 80,
                        backgroundImage: _image != null ? FileImage(_image!) as ImageProvider<Object>: const AssetImage('lib/assets/profilePicture.jpg') as ImageProvider<Object>,
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
                  child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(hintText: 'Anne', width1: 0.38),
                        InputFields(hintText: 'Fernando', width1: 0.38),
                      ],
                    ),

                    const SizedBox(height: 15),

                    InputFields(hintText: 'Anne_fernando82', width1: 0.8),

                    const SizedBox(height: 15),

                    InputFields(hintText: 'Anne1234', width1: 0.8),

                    const SizedBox(height: 15),

                    InputFields(
                      validator: (value) {
                        String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';    //format: username@domain.extension.
                        RegExp emailRegex = RegExp(emailPattern);

                        if (!emailRegex.hasMatch(value!)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      hintText: 'annefernando82@gmail.com', 
                      width1: 0.8
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width * 0.25, // adjust as needed
                          color: const Color(0xFFFAFAFA), // to visualize the container
                          child: DropdownInputField(  // use the custom DropdownInputField widget
                            dropdownItems: ['+94'],
                            hintText: '+94',
                            initialValue: '+94',
                          ),
                        ),

                        InputFields(
                          hintText: '712345678', 
                          width1: 0.5, 
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            // Check if the phone number is valid
                            final phoneRegExp = RegExp(r'^\d{9}$');
                            if (!phoneRegExp.hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),

                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InputFields(hintText: 'Colombo', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                        // InputFields(hintText: 'Western', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),

                        Container(
                          width: MediaQuery.of(context).size.width * 0.38, // adjust as needed
                          color: const Color(0xFFFAFAFA), // to visualize the container
                          child: DropdownInputField(  // use the custom DropdownInputField widget
                            dropdownItems: ['Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle', 'Kilinochchi', 'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'],
                            hintText: 'District',
                            initialValue: 'Colombo',
                          ),
                        ),

                        //"'package:flutter/src/material/dropdown.dart':Failed assertion:line 1619 pos 15: 'items == null || items.isEmpty || value == null || items.

                        Container(
                          width: MediaQuery.of(context).size.width * 0.38, // adjust as needed
                          color: const Color(0xFFFAFAFA), // to visualize the container
                          child: DropdownInputField(  // use the custom DropdownInputField widget
                            dropdownItems: ['Central', 'Eastern', 'North Central', 'Northern', 'North Western', 'Sabaragamuwa', 'Southern', 'Uva', 'Western'],
                            hintText: 'Province',
                            initialValue: 'Western',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    CustomButton(
                      onPressed: () {
                        // Navigate to the add vehicle page
                        submitForm();
                      }, 
                      text: 'Save',
                    )

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
    if (formKey.currentState?.validate() ?? false) {
      // Continue with form submission
    }
  }
}