import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/dropdowns/condition.dart';
import 'package:panchikawatta/dropdowns/fuel.dart';
import 'package:panchikawatta/dropdowns/origin.dart';
import 'package:panchikawatta/dropdowns/vehicle_make.dart';
import 'package:panchikawatta/dropdowns/vehicle_model.dart';
import 'package:panchikawatta/dropdowns/vehicle_type.dart';
import 'package:panchikawatta/screens/User/filtered_list.dart';
import 'package:panchikawatta/models/sparepart.dart';
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
      final List ads = await FilterApiService().fetchFilteredAds(
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
          builder: (context) => FilteredSparePartsScreen(
              filteredSpareParts:
                  ads.map((ad) => SparePart.fromJson(ad)).toList()),
        ),
      );
    } catch (error) {
      print('Failed to fetch filtered ads: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> makes = selectedVehicleType != null &&
            vehicleTypeToMakes.containsKey(selectedVehicleType)
        ? vehicleTypeToMakes[selectedVehicleType]!
        : [];

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
              selectedType: selectedVehicleType,
              selectedMake: selectedVehicleMake,
              makes: makes,
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
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Min Year'),
                    value: selectedMinYear,
                    items: List.generate(
                      DateTime.now().year - 1990 + 1,
                      (index) => DropdownMenuItem(
                        value: (1990 + index).toString(),
                        child: Text((1990 + index).toString()),
                      ),
                    ),
                    onChanged: (String? year) {
                      setState(() {
                        selectedMinYear = year;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Max Year'),
                    value: selectedMaxYear,
                    items: List.generate(
                      DateTime.now().year - 1990 + 1,
                      (index) => DropdownMenuItem(
                        value: (1990 + index).toString(),
                        child: Text((1990 + index).toString()),
                      ),
                    ),
                    onChanged: (String? year) {
                      setState(() {
                        selectedMaxYear = year;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Apply',
              onPressed: fetchFilteredAds,
            ),
          ],
        ),
      ),
    );
  }
}
