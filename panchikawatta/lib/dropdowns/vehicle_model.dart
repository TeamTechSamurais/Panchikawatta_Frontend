// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class VehicleModel extends StatefulWidget {
  final String? selectedModel;
  final List<String> models;
  final Function(String?)? onChanged;

  const VehicleModel(
      {super.key, this.selectedModel, required this.models, this.onChanged});

  @override
  _VehicleModelState createState() => _VehicleModelState();
}

class _VehicleModelState extends State<VehicleModel> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedModel,
      hint: const Text('Model'),
      items: widget.models.map((String model) {
        return DropdownMenuItem<String>(
          value: model,
          child: Text(model),
        );
      }).toList(),
      onChanged: widget.onChanged,
      isExpanded: true,
    );
  }
}

Map<String, List<String>> vehicleMakeToModels = {
  'Any': ['Any'],
  // Car Makes
  'Toyota': ['Corolla', 'Vitz', 'Prius', 'Hilux', 'Land Cruiser'],
  'Honda': ['Civic', 'Fit', 'Accord', 'CR-V', 'HR-V'],
  'Nissan': ['Leaf', 'Sunny', 'Juke', 'X-Trail', 'Navara'],
  'Suzuki': ['Alto', 'Swift', 'Wagon R', 'Baleno', 'Vitara'],
  'Hyundai': ['Elantra', 'Santa Fe', 'Tucson', 'i10', 'Sonata'],
  'Mitsubishi': ['Lancer', 'Outlander', 'Pajero', 'Mirage', 'Montero'],
  'Mazda': ['Demio', 'Axela', 'CX-5', 'Atenza', 'CX-3'],
  'Kia': ['Picanto', 'Sportage', 'Sorento', 'Rio', 'Cerato'],
  'BMW': ['3 Series', '5 Series', 'X1', 'X3', 'X5'],
  'Mercedes-Benz': ['C-Class', 'E-Class', 'A-Class', 'GLE', 'GLB'],

  // Motorcycle Makes
  'Honda bike': ['CBR', 'Activa', 'Shine', 'Dio'],
  'Yamaha': ['R15', 'FZ', 'MT-15', 'Fascino', 'Ray ZR'],
  'Suzuki bike': ['Gixxer', 'Access', 'Intruder', 'Burgman', 'Hayabusa'],
  'Kawasaki': ['Ninja 300', 'Z650', 'Versys', 'Vulcan', 'KX450'],
  'Ducati': [
    'Panigale V4',
    'Monster 821',
    'Multistrada 950',
    'Scrambler 1100',
    'Diavel 1260'
  ],

  // Three-Wheeler Makes
  'Bajaj Three-Wheeler': ['RE', 'Maxima', 'Compact RE', 'Maxima C', 'Maxima Z'],
  'TVS Three-Wheeler': [
    'King',
    'XL100',
    'King Deluxe',
    'King Duramax',
    'King Super'
  ],
  'Piaggio': ['Ape', 'Porter', 'Diesel Ape', 'City', 'Mini Ape'],

  // Bus Makes
  'Ashok Leyland': ['Lynx', 'Cheetah', 'Falcon', 'Stag', 'Viking'],
  'Tata': ['Starbus', 'Ultra', 'LP', 'LPO', 'Cityride'],
  'Mercedes-Benz Bus': ['Citaro', 'Intouro', 'Tourismo', 'Travego', 'Sprinter'],
  'Volvo': ['B8R', 'B11R', '9700', '9900', '7900'],
  'Eicher': ['Skyline', 'Starline', 'Pro', 'Sure', 'Eagle'],

  // Van Makes
  'Toyota van': ['Hiace', 'Noah', 'Voxy', 'Alphard', 'Granvia'],
  'Nissan van': ['Caravan', 'NV350', 'Vanette', 'Elgrand', 'Serena'],
  'Mitsubishi van': ['Delica', 'L300', 'Pajero Sport', 'Express', 'Rosa'],
  'Suzuki van': ['Every', 'Carry', 'APV', 'Ertiga', 'Jimny'],
  'Honda van': ['Stepwgn', 'Elysion', 'Freed', 'Odyssey', 'Mobilio'],

  // SUV Makes
  'Toyota SUV': ['Land Cruiser', 'Prado', 'Fortuner', 'RAV4', 'C-HR'],
  'Honda SUV': ['CR-V', 'HR-V', 'Pilot', 'Passport', 'Element'],
  'Nissan SUV': ['X-Trail', 'Qashqai', 'Patrol', 'Terrano', 'Kicks'],
  'Kia SUV': ['Sportage', 'Sorento', 'Seltos', 'Telluride', 'Niro'],
};
