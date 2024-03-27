// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/add_image.dart';
import 'package:panchikawatta/components/checkbox.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/adPost2.dart';

class AdPost1 extends StatefulWidget {
  const AdPost1({super.key});

  @override
  _AdPost1State createState() => _AdPost1State();
}

class _AdPost1State extends State<AdPost1> {
  String _selectedType = 'Spare Parts';

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
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Type',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Spare Parts',
                          groupValue: _selectedType,
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                          activeColor: const Color(0xFFFF5C01),
                        ),
                        const Text(
                          'Spare Parts',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Radio<String>(
                          value: 'Services',
                          groupValue: _selectedType,
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                          activeColor: const Color(0xFFFF5C01),
                        ),
                        const Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const InputFields(hintText: 'Title', width1: 1),
                    const SizedBox(height: 10),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    const Text(
                      'Add Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Add_Image(size: 70, color: Color(0xFF999999)),
                        Add_Image(size: 70, color: Color(0xFF999999)),
                        Add_Image(size: 70, color: Color(0xFF999999)),
                        Add_Image(size: 70, color: Color(0xFF999999)),
                      ],
                    )
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
                    InputFields(
                      hintText: 'Price',
                      width1: 1,
                    ),
                    SizedBox(height: 10),
                    Row(children: [
                      CustomCheckbox(),
                      Text(
                        'Negotioble',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])
                  ],
                ),
              ),
              Center(
                child: CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdPost2(key: UniqueKey())),
                    );
                  },
                  text: 'Next',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
