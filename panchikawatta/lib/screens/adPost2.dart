// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/dropdowns/condition_post.dart';
import 'package:panchikawatta/dropdowns/fuel_post.dart';
import 'package:panchikawatta/dropdowns/origin.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/screens/post_success.dart';
import 'package:panchikawatta/services/api_service.dart';

class AdPost2 extends StatefulWidget {
  final int sparePartId;

  AdPost2({super.key, required this.sparePartId});

  @override
  _AdPost2State createState() => _AdPost2State();
  final ApiService apiService = ApiService();
}

class _AdPost2State extends State<AdPost2> {
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedOrigin;
  String? _selectedCondition;
  String? _selectedFuel;
  final TextEditingController _yearController = TextEditingController();

  Future<void> _postSparePartStep2() async {
    try {
      final make = _selectedMake;
      final model = _selectedModel;
      final origin = _selectedOrigin;
      final condition = _selectedCondition;
      final fuel = _selectedFuel;
      final year = int.tryParse(_yearController.text);

      if (make == null ||
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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostSuccess()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload spare part details: $e')),
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
              const Text(
                'Make',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              VehicleMake(
                selectedMake: _selectedMake,
                onChanged: (String? make) {
                  setState(() {
                    _selectedMake = make;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Model',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              VehicleModel(
                selectedModel: _selectedModel,
                models: vehicleMakeToModels[_selectedMake] ?? [],
                onChanged: (String? model) {
                  setState(() {
                    _selectedModel = model;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Year',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              InputFields(
                controller: _yearController,
                hintText: 'Year',
                width1: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                'Origin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              OriginDropdown(
                onChanged: (value) {
                  setState(() {
                    _selectedOrigin = value;
                  });
                },
                selectedOrigin: _selectedOrigin,
              ),
              const SizedBox(height: 20),
              const Text(
                'Condition',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Condition(
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value;
                  });
                },
                selectedCondition: _selectedCondition,
              ),
              const SizedBox(height: 20),
              const Text(
                'Fuel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Fuel(
                onChanged: (value) {
                  setState(() {
                    _selectedFuel = value;
                  });
                },
                selectedFuel: _selectedFuel,
              ),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    await _postSparePartStep2();
                  },
                  text: 'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
