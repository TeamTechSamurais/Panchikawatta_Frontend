// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api, file_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/add_image.dart';
import 'package:panchikawatta/screens/AdPost/post_unsuccess.dart';
import 'package:panchikawatta/services/post_api_service.dart';
import 'package:panchikawatta/dropdowns/condition_post.dart';
import 'package:panchikawatta/dropdowns/fuel_post.dart';
import 'package:panchikawatta/dropdowns/origin.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/dropdowns/vehicle_type.dart';
import 'package:panchikawatta/screens/AdPost/post_success.dart';
import 'package:panchikawatta/global/globals.dart' as globals;

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

class AdPost extends StatefulWidget {
  AdPost({super.key});

  @override
  _AdPostState createState() => _AdPostState();
  final PostApiService apiService = PostApiService();
}

class _AdPostState extends State<AdPost> {
  final List<XFile?> _images = List<XFile?>.filled(1, null);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedType;
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedOrigin;
  String? _selectedCondition;
  String? _selectedFuel;
  final TextEditingController _yearController = TextEditingController();

  void _setImage(int index, XFile? imagepath) {
    setState(() {
      _images[index] = imagepath;
    });
  }

  Future<List<String>> _uploadImages(List<XFile?> images) async {
    List<String> downloadUrls = [];
    for (XFile? imagepath in images) {
      if (imagepath != null) {
        String downloadUrl = await _uploadImage(imagepath);
        downloadUrls.add(downloadUrl);
      } else {
        print("Error: Image path is null");
      }
      print("Download URLs: $downloadUrls");
    }
    return downloadUrls;
  }

  Future<String> _uploadImage(XFile imagepath) async {
    try {
      File file = File(imagepath.path);

      // Upload the file to Firebase Storage
      TaskSnapshot snapshot = await _storage
          .ref('sparepart_image/${file.path.split('/').last}')
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

  Future<void> _postSparePart() async {
    try {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final price = int.tryParse(_priceController.text);
      final type = _selectedType;
      final make = _selectedMake;
      final model = _selectedModel;
      final origin = _selectedOrigin;
      final condition = _selectedCondition;
      final fuel = _selectedFuel;
      final year = int.tryParse(_yearController.text);

      if (title.isEmpty ||
          description.isEmpty ||
          price == null ||
          type == null ||
          make == null ||
          model == null ||
          origin == null ||
          condition == null ||
          fuel == null ||
          year == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      List<String> downloadUrls = await _uploadImages(_images);

      final sparePart = await widget.apiService.postSparePart(
        sellerId: globals.userId!,
        title: title,
        description: description,
        price: price,
        imageUrls: downloadUrls,
        type: type,
        make: make,
        model: model,
        origin: origin,
        condition: condition,
        fuel: fuel,
        year: year,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PostSuccess()),
      );
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PostUnsuccess()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post ad: $e')),
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
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Title',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xCC000000),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEBEBEB),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Price',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xCC000000),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEBEBEB),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Add Images',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AddImage(
                    size: 70,
                    color: Colors.grey,
                    onImageSelected: (image) {
                      _setImage(0, image);
                    },
                  ),
                  AddImage(
                    size: 70,
                    color: Colors.grey,
                    onImageSelected: (image) {
                      _setImage(1, image);
                    },
                  ),
                  AddImage(
                    size: 70,
                    color: Colors.grey,
                    onImageSelected: (image) {
                      _setImage(2, image);
                    },
                  ),
                ],
              ),
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
                      'Select relevant vehicle details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    VehicleType(
                      selectedType: _selectedType,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    VehicleMake(
                      selectedMake: _selectedMake,
                      makes: vehicleTypeToMakes[_selectedType] ?? [],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedMake = value;
                          _selectedModel =
                              null; // Reset model when make changes
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    VehicleModel(
                      selectedModel: _selectedModel,
                      models: vehicleMakeToModels[_selectedMake] ?? [],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedModel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    OriginDropdown(
                      selectedOrigin: _selectedOrigin,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOrigin = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Condition(
                      selectedCondition: _selectedCondition,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCondition = value;
                        });
                      },
                    ),
                    Fuel(
                      selectedFuel: _selectedFuel,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFuel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Year',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xCC000000),
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEBEBEB),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Post Ad',
                onPressed: _postSparePart,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
