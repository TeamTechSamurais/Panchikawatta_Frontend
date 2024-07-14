import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/dropdowns/condition.dart';
import 'package:panchikawatta/dropdowns/fuel.dart';
import 'package:panchikawatta/dropdowns/origin.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/dropdowns/vehicle_type.dart';
import 'package:panchikawatta/screens/app.dart';
import 'package:panchikawatta/services/filter_api_service.dart';

class FilterSortScreen extends StatefulWidget {
  const FilterSortScreen({Key? key}) : super(key: key);

  @override
  _FilterSortScreenState createState() => _FilterSortScreenState();
}

class _FilterSortScreenState extends State<FilterSortScreen> {
  String? selectedVehicleType;
  String? selectedVehicleMake;
  String? selectedModel;
  String? selectedOrigin;
  String? selectedMinYear;
  String? selectedMaxYear;

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  Set<String> selectedConditions = {};
  String? selectedFuel;

  Future<void> fetchFilteredAds() async {
    try {
      final ads = await FilterApiService().fetchFilteredAds(
        type: selectedVehicleType,
        vehicleMake: selectedVehicleMake,
        model: selectedModel,
        origin: selectedOrigin,
        minPrice: minPriceController.text,
        maxPrice: maxPriceController.text,
        conditions: selectedConditions.toList(),
        fuelTypes: selectedFuel != null ? [selectedFuel!] : [],
        minYear: selectedMinYear,
        maxYear: selectedMaxYear,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } catch (error) {
      print('Failed to fetch filtered ads: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> models = selectedVehicleMake != null &&
            vehicleMakeToModels.containsKey(selectedVehicleMake)
        ? vehicleMakeToModels[selectedVehicleMake]!
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filter Results',
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
            VehicleType(
              selectedType: selectedVehicleType,
              onChanged: (String? type) {
                setState(() {
                  selectedVehicleType = type;
                  selectedVehicleMake = null;
                  selectedModel = null;
                });
              },
            ),
            const SizedBox(height: 16),
            VehicleMake(
              selectedMake: selectedVehicleMake,
              makes: vehicleMakeToModels[selectedVehicleMake] ?? [],
              onChanged: (String? make) {
                setState(() {
                  selectedVehicleMake = make;
                  selectedModel = null;
                });
              },
            ),
            const SizedBox(height: 16),
            VehicleModel(
              selectedModel: selectedModel,
              models: models,
              onChanged: (String? model) {
                setState(() {
                  selectedModel = model;
                });
              },
            ),
            const SizedBox(height: 16),
            OriginDropdown(
              selectedOrigin: selectedOrigin,
              onChanged: (String? origin) {
                setState(() {
                  selectedOrigin = origin;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Min Price'),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('-'),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Max Price'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ConditionDropdown(
              selectedConditions: selectedConditions,
              onChanged: (Set<String> conditions) {
                setState(() {
                  selectedConditions = conditions;
                });
              },
            ),
            const SizedBox(height: 16),
            FuelDropdown(
              selectedFuel: selectedFuel,
              onChanged: (String? fuel) {
                setState(() {
                  selectedFuel = fuel;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: selectedMinYear),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Min Year'),
                    onChanged: (value) {
                      setState(() {
                        selectedMinYear = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Text('-'),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: selectedMaxYear),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Max Year'),
                    onChanged: (value) {
                      setState(() {
                        selectedMaxYear = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () {
                    setState(() {
                      selectedVehicleMake = null;
                      selectedModel = null;
                      selectedOrigin = null;
                      selectedMinYear = null;
                      selectedMaxYear = null;
                      minPriceController.clear();
                      maxPriceController.clear();
                      selectedConditions.clear();
                      selectedFuel = null;
                    });
                  },
                  text: 'Reset',
                ),
                CustomButton(
                  onPressed: fetchFilteredAds,
                  text: 'Apply',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
