// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/dropdowns/condition.dart';
import 'package:panchikawatta/dropdowns/district.dart';
import 'package:panchikawatta/dropdowns/origin.dart';
import 'package:panchikawatta/dropdowns/province.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/screens/search_page.dart';

class FilterSortScreen extends StatefulWidget {
  const FilterSortScreen({super.key});

  @override
  _FilterSortScreenState createState() => _FilterSortScreenState();
}

class _FilterSortScreenState extends State<FilterSortScreen> {
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedVehicleMake;
  String? selectedModel;
  String? selectedOrigin;
  String? selectedMinYear;
  String? selectedMaxYear;

  final List<String> origins = ['Japan', 'UK', 'Germany', 'USA', 'India'];
  final List<String> conditions = ['New', 'Used', 'Reconditioned'];
  final List<String> fuelTypes = ['Petrol', 'Diesel', 'Hybrid', 'Electric'];

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  Set<String> selectedConditions = {};
  Set<String> selectedFuelTypes = {};

  get minYearController => null;

  get maxYearController => null;

  @override
  Widget build(BuildContext context) {
    List<String> models = selectedVehicleMake != null &&
            vehicleMakeToModels.containsKey(selectedVehicleMake)
        ? vehicleMakeToModels[selectedVehicleMake]!
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter and Sort',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: ProvinceDropdown(
                    selectedProvince: selectedProvince,
                    onChanged: (String? province) {
                      setState(() {
                        selectedProvince = province;
                        selectedDistrict =
                            null; // Reset district when province changes
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DistrictDropdown(
                    selectedDistrict: selectedDistrict,
                    selectedProvince: selectedProvince,
                    onChanged: (String? district) {
                      setState(() {
                        selectedDistrict = district;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            VehicleMake(
              selectedMake: selectedVehicleMake,
              onChanged: (String? make) {
                setState(() {
                  selectedVehicleMake = make;
                  selectedModel = null; // Reset model when make changes
                });
              },
            ),
            SizedBox(height: 16),
            VehicleModel(
              selectedModel: selectedModel,
              models: models,
              onChanged: (String? model) {
                setState(() {
                  selectedModel = model;
                });
              },
            ),
            SizedBox(height: 16),
            OriginDropdown(
              selectedOrigin: selectedOrigin,
              onChanged: (String? origin) {
                setState(() {
                  selectedOrigin = origin;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Price'),
                  ),
                ),
                SizedBox(width: 16),
                Text('-'),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Price'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ConditionDropdown(
              selectedConditions: selectedConditions,
              onChanged: (Set<String> conditions) {
                setState(() {
                  selectedConditions = conditions;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Fuel'),
            Wrap(
              spacing: 8,
              children: fuelTypes.map((fuel) {
                return ChoiceChip(
                  label: Text(fuel),
                  selected: selectedFuelTypes.contains(fuel),
                  selectedColor: Color.fromARGB(255, 248, 159, 112),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedFuelTypes.add(fuel);
                      } else {
                        selectedFuelTypes.remove(fuel);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Min Year'),
                  ),
                ),
                SizedBox(width: 16),
                Text('-'),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: maxYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Max Year'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                    onPressed: () {
                      setState(() {
                        selectedProvince = null;
                        selectedDistrict = null;
                        selectedVehicleMake = null;
                        selectedModel = null;
                        selectedOrigin = null;
                        selectedMinYear = null;
                        selectedMaxYear = null;
                        minPriceController.clear();
                        maxPriceController.clear();
                        selectedConditions.clear();
                        selectedFuelTypes.clear();
                      });
                    },
                    text: 'Reset'),
                CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => search_page(),
                        ),
                      );
                    },
                    text: 'Apply')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
