import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'dart:io';
import 'package:panchikawatta/screens/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  File? _image;

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
                          // if (selectedImage != null) {
                            setState(() {
                              _image = selectedImage;
                            });
                          // }
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return ImagePickerPage();
                          //   },
                          // );
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
                child: Column(
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

                    InputFields(hintText: 'annefernando82@gmail.com', width1: 0.8),

                    const SizedBox(height: 15),

                    InputFields(hintText: '0712345678', width1: 0.8),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputFields(hintText: 'Colombo', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                        InputFields(hintText: 'Western', width1: 0.38, suffixIcon: const Icon(Icons.expand_more, size: 30, color: Color(0xCC000000))),
                      ],
                    ),

                    const SizedBox(height: 15),

                    CustomButton(
                      onPressed: () {
                        // Navigate to the add vehicle page
                      }, 
                      text: 'Save',)

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