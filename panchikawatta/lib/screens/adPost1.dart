// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/adPost2.dart';
import 'package:panchikawatta/components/add_image.dart';
import 'package:panchikawatta/services/api_service.dart';

class AdPost1 extends StatefulWidget {
  AdPost1({super.key});

  @override
  _AdPost1State createState() => _AdPost1State();
  final ApiService apiService = ApiService();
}

class _AdPost1State extends State<AdPost1> {
  final List<XFile?> _images = List<XFile?>.filled(1, null);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _setImage(int index, XFile? image) {
    setState(() {
      _images[index] = image;
    });
  }

  Future<void> _postSparePartStep1() async {
    try {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final price = int.tryParse(_priceController.text);
      final image = _images[0];

      if (title.isEmpty || description.isEmpty || price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      final sparePart = await widget.apiService.postSparePartStep1(
        sellerId: 2, // Replace with actual seller ID
        title: title,
        description: description,
        price: price,
        image: image!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdPost2(sparePartId: sparePart.id),
        ),
      );
    } catch (e) {
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
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InputFields(
                      controller: _titleController,
                      hintText: 'Title',
                      width1: 1,
                    ),
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
                      children: List.generate(1, (index) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InputFields(
                      controller: _priceController,
                      hintText: 'Price',
                      width1: 1,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    await _postSparePartStep1();
                  },
                  text: 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
