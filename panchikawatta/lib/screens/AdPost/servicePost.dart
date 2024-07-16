import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/add_image.dart';
import 'package:panchikawatta/dropdowns/service_type.dart';
import 'package:panchikawatta/screens/AdPost/post_success.dart';
import 'package:panchikawatta/services/post_api_service.dart';
import 'package:panchikawatta/global/globals.dart' as globals;

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

class ServicePost extends StatefulWidget {
  ServicePost({super.key});

  @override
  _ServicePostState createState() => _ServicePostState();
  final PostApiService apiService = PostApiService();
}

class _ServicePostState extends State<ServicePost> {
  XFile? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedServiceType;

  void _setImage(XFile? imagepath) {
    setState(() {
      _image = imagepath;
    });
  }

  Future<String> _uploadImage(XFile imagepath) async {
    try {
      File file = File(imagepath.path);

      // Upload the file to Firebase Storage
      TaskSnapshot snapshot = await _storage
          .ref('service_images/${file.path.split('/').last}')
          .putFile(file);

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("\nImage uploaded successfully");
      return downloadUrl;
    } catch (e) {
      // Handle any errors that occur during the process
      print("Error uploading image: $e");
      throw e; // Optionally rethrow the exception to handle it elsewhere if needed
    }
  }

  Future<void> _postService() async {
    try {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final price = int.tryParse(_priceController.text);
      int? sellerId = globals.userId;

      // Debug prints to check the values
      print('Title: $title');
      print('Description: $description');
      print('Price: $price');
      print('Service Type: $_selectedServiceType');
      print('Seller ID: $sellerId');

      if (title.isEmpty ||
          description.isEmpty ||
          _selectedServiceType == null ||
          price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      String downloadUrl = '';
      if (_image != null) {
        downloadUrl = await _uploadImage(_image!);
      } else {
        print("Error: Image is null");
      }

      final response = await widget.apiService.postService(
        sellerId: sellerId!,
        title: title,
        description: description,
        price: price.toString(),
        imageUrls: [downloadUrl],
      );

      // Debug print response
      print('Response: ${response.toString()}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PostSuccess(),
        ),
      );
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post service: $e')),
      );
    }
  }

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
          'Post Service Ad',
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
                    ServiceType(
                      selectedService: _selectedServiceType,
                      onChanged: (value) {
                        setState(() {
                          _selectedServiceType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEBEBEB),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
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
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        hintText: 'Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEBEBEB),
                      ),
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
                      children: [
                        AddImage(
                          size: 70,
                          color: Colors.grey,
                          onImageSelected: (image) {
                            _setImage(image);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    await _postService();
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
