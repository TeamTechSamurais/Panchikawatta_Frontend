// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/dropdowns/condition.dart';
import 'package:panchikawatta/dropdowns/fuel.dart';
import 'package:panchikawatta/dropdowns/origin.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/screens/adPost1.dart';
import 'package:panchikawatta/screens/post_success.dart';

class AdPost2 extends StatefulWidget {
  const AdPost2({super.key});

  @override
  _AdPost2State createState() => _AdPost2State();
}

List<String> makes = [
  'Toyota',
  'Nissan',
  'Audi',
  'BMW',
  'Mercedes',
  'Honda',
];
List<String> models = [
  'Corolla',
  'Vitz',
  'Q2',
  '3 Series',
  'Benz',
  'Civic',
];
List<String> origin = [
  'Local',
  'Japan',
  'UK',
  'Germany',
  'USA',
  'India',
];

List<String> conditions = [
  'New',
  'Used',
  'Reconditioned',
];

List<String> fuel = [
  'Petrol',
  'Diesel',
  'Electric',
  'Hybrid',
  'Any',
];

class _AdPost2State extends State<AdPost2> {
  String? _selectedMake; // Variable to store the selected vehicle make
  String? _selectedModel; // Variable to store the selected vehicle model
  String? _selectedOrigin; // Variable to store the selected vehicle origin
  String?
      _selectedCondition; // Variable to store the selected vehicle condition
  String? _selectedFuel; // Variable to store the selected vehicle fuel

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
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Make',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Expanded(
                            child: VehicleMake(
                              selectedMake: _selectedMake,
                              makes: makes, // List of vehicle makes
                              onChanged: (String? make) {
                                setState(() {
                                  _selectedMake = make;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Model',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 95,
                          ),
                          Expanded(
                            child: VehicleModel(
                              selectedModel: _selectedModel,
                              models: models, // List of vehicle models
                              onChanged: (String? model) {
                                setState(() {
                                  _selectedModel = model;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Origin',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 97,
                          ),
                          Expanded(
                            child: Origin(
                              selectedOrigin: _selectedOrigin,
                              origin: origin, // List of vehicle models
                              onChanged: (String? origin) {
                                setState(() {
                                  _selectedOrigin = origin;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Condition',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 67,
                          ),
                          Expanded(
                            child: Condition(
                              selectedCondition: _selectedCondition,
                              condition: conditions, // List of vehicle models
                              onChanged: (String? origin) {
                                setState(() {
                                  _selectedOrigin = origin;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Fuel',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 110,
                          ),
                          Expanded(
                            child: Fuel(
                              selectedFuel: _selectedFuel,
                              fuel: fuel,
                              onChanged: (String? fuel) {
                                setState(() {
                                  _selectedFuel = fuel;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Year',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 105,
                          ),
                          Expanded(
                            child: InputFields(hintText: 'Year', width1: 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdPost1()));
                          },
                          text: 'Previous',
                        ),
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostSuccess()));
                          },
                          text: 'Post',
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
