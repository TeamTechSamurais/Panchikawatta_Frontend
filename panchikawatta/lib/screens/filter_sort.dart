// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
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

  final List<String> provinces = ['Province1', 'Province2', 'Province3'];
  final List<String> districts = ['District1', 'District2', 'District3'];
  final List<String> vehicleMakes = ['Make1', 'Make2', 'Make3'];
  final List<String> models = ['Model1', 'Model2', 'Model3'];
  final List<String> origins = ['Origin1', 'Origin2', 'Origin3'];
  final List<String> conditions = ['New', 'Used', 'Reconditioned'];
  final List<String> fuelTypes = ['Petrol', 'Diesel', 'Hybrid', 'Electric'];

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minYearController = TextEditingController();
  final TextEditingController maxYearController = TextEditingController();

  Set<String> selectedConditions = {};
  Set<String> selectedFuelTypes = {};

  @override
  Widget build(BuildContext context) {
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
            // Text('Location', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedProvince,
                    decoration: InputDecoration(labelText: 'Province'),
                    items: provinces.map((province) {
                      return DropdownMenuItem<String>(
                        value: province,
                        child: Text(province),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvince = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    decoration: InputDecoration(labelText: 'District'),
                    items: districts.map((district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Text('Vehicle Make'),
            DropdownButtonFormField<String>(
              value: selectedVehicleMake,
              decoration: InputDecoration(labelText: 'Vehicle Make'),
              items: vehicleMakes.map((make) {
                return DropdownMenuItem<String>(
                  value: make,
                  child: Text(make),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVehicleMake = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Text('Model'),
            DropdownButtonFormField<String>(
              value: selectedModel,
              decoration: InputDecoration(labelText: 'Model'),
              items: models.map((model) {
                return DropdownMenuItem<String>(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedModel = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Text('Origin'),
            DropdownButtonFormField<String>(
              value: selectedOrigin,
              decoration: InputDecoration(labelText: 'Origin'),
              items: origins.map((origin) {
                return DropdownMenuItem<String>(
                  value: origin,
                  child: Text(origin),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOrigin = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Text('Price'),
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
            Text('Condition'),
            Wrap(
              spacing: 8,
              children: conditions.map((condition) {
                return ChoiceChip(
                  label: Text(condition),
                  selected: selectedConditions.contains(condition),
                  selectedColor: Color.fromARGB(255, 248, 159, 112),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedConditions.add(condition);
                      } else {
                        selectedConditions.remove(condition);
                      }
                    });
                  },
                );
              }).toList(),
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
            Text('Year'),
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
                        minPriceController.clear();
                        maxPriceController.clear();
                        minYearController.clear();
                        maxYearController.clear();
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
