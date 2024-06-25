// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/adPost2.dart';
import 'package:panchikawatta/screens/post_success.dart';
import 'package:panchikawatta/components/add_image.dart';

class ServicePost extends StatefulWidget {
  const ServicePost({super.key});

  @override
  _ServicePostState createState() => _ServicePostState();
}

class _ServicePostState extends State<ServicePost> {
  final String _selectedType = 'Services';
  final List<XFile?> _images = List<XFile?>.filled(4, null);

  void _setImage(int index, XFile? image) {
    setState(() {
      _images[index] = image;
    });
  }

  // Future<void> _uploadImages() async {
  //   final uri = Uri.parse('http://10.0.2.2:8000/upload');
  //   final request = http.MultipartRequest('POST', uri);
  //   for (var image in _images) {
  //     if (image != null) {
  //       request.files.add(
  //         http.MultipartFile.fromBytes(
  //           'images',
  //           File(image.path).readAsBytesSync(),
  //           filename: image.name,
  //         ),
  //       );
  //     }
  //   }
  Future<void> _mockUploadImages() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // Simulate a successful upload response
    const responseCode = 201;
    if (responseCode == 201) {
      print('Upload successful: {"message": "Success"}');
    } else {
      print('Upload failed with status: $responseCode');
    }
  }

  // request.fields['title'] = 'Your Ad Title';
  // request.fields['description'] = 'Your Ad Description';
  // request.fields['price'] = '1000';

  //   final response = await request.send();
  //   if (response.statusCode == 201) {
  //     final responseBody = await response.stream.bytesToString();
  //     final jsonResponse = jsonDecode(responseBody);
  //     print('Upload successful: $jsonResponse');
  //   } else {
  //     print('Upload failed with status: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Post Ad',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const InputFields(hintText: 'Title', width1: 1),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Description',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xCC000000),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEBEBEB),
                      ),
                      minLines: 3,
                      maxLines: null,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Add Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        return AddImage(
                          size: 70,
                          color: const Color(0xFF999999),
                          onImageSelected: (image) => _setImage(index, image),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    InputFields(
                      hintText: 'Price',
                      width1: 1,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    await _mockUploadImages();
                    if (_selectedType == 'Services') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostSuccess()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostSuccess()),
                      );
                    }
                  },
                  text: 'Post Ad',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
