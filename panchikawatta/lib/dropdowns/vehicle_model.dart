// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class VehicleModel extends StatefulWidget {
  final String? selectedModel;
  final List<String> models;
  final Function(String?)? onChanged;

  const VehicleModel(
      {super.key,
      this.selectedModel,
      required this.models,
      this.onChanged,
      String? selectedMake});

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
  'Honda Motorcycle': ['CB Shine', 'Dio', 'Unicorn', 'CB Hornet', 'Activa'],
  'Yamaha': ['FZ', 'R15', 'Fazer', 'Saluto', 'Ray ZR'],
  'Bajaj': ['Pulsar', 'Discover', 'Platina', 'Dominar', 'Avenger'],
  'TVS': ['Apache', 'Star City', 'Jupiter', 'Radeon', 'Ntorq'],
  'Hero': ['Splendor', 'Passion', 'Xtreme', 'Glamour', 'Maestro'],
  'Bajaj Three-Wheeler': [
    'RE Compact',
    'RE Maxima',
    'RE Compact Plus',
    'RE Compact Diesel',
    'RE Diesel'
  ],
  'Piaggio': [
    'Ape City',
    'Ape DX',
    'Ape City CNG',
    'Ape Xtra LD',
    'Ape Xtra LDX'
  ],
  'Mahindra': [
    'Alfa DX',
    'Alfa Champion',
    'Alfa Load',
    'Alfa Passenger',
    'Alfa Load Plus'
  ],
  'TVS Three-Wheeler': [
    'King Deluxe',
    'King Petrol',
    'King LPG',
    'King 4S',
    'King Duramax'
  ],
  'Tata Truck': [
    'LPK 1615',
    'LPT 3718',
    'Ultra 1918',
    'Signa 4018',
    'Ace Gold'
  ],
  'Isuzu Truck': ['NMR 250', 'NPR 75', 'FRR 90', 'FTR 90', 'NQR 87'],
  'Ashok Leyland Truck': [
    '1616',
    'Boss 1412',
    '1618',
    'Captain 2523',
    'Partner 4W'
  ],
  'Mitsubishi Fuso Truck': [
    'Fighter',
    'Canter',
    'Super Great',
    'Rosa',
    'Fighter 6D'
  ],
  'Eicher Truck': ['Pro 1049', 'Pro 1075', 'Pro 3015', 'Pro 6016', 'Pro 8031'],
  'Tata': ['Starbus', 'Marcopolo', 'Ultra', 'CityRide', 'LPO'],
  'Ashok Leyland': ['Viking', 'Lynx', 'Falcon', 'Titan', 'Panther'],
  'Eicher': ['Skyline', 'Starline', 'Rapidline', 'Skyline Pro', 'Starline S'],
  'Mitsubishi Fuso': [
    'Rosa',
    'Aero Queen',
    'Aero King',
    'Aero Midi',
    'Aero Star'
  ],
  'Toyota Van': ['Hiace', 'Dolphin', 'Townace', 'Liteace', 'Regius'],
  'Nissan Van': ['Caravan', 'NV200', 'NV350', 'Urvan', 'Vanette'],
  'Mitsubishi Van': ['Delica', 'L300', 'L400', 'Express', 'Canter Van'],
  'Mazda Van': ['Bongo', 'E2000', 'Bongo Friendee', 'Mazda5', 'Bongo Brawny'],
  'Suzuki Van': ['Every', 'Carry', 'APV', 'Bolan', 'Ertiga'],
  'Honda Van': ['Acty', 'Freed', 'Partner', 'StepWGN', 'Elysion'],
  'Toyota SUV': ['Land Cruiser', 'Prado', 'Fortuner', 'Rush', 'C-HR'],
  'Honda SUV': ['CR-V', 'HR-V', 'BR-V', 'Passport', 'Pilot'],
  'Mitsubishi SUV': ['Pajero', 'Montero', 'Outlander', 'Eclipse Cross', 'RVR'],
  'Nissan SUV': ['X-Trail', 'Patrol', 'Qashqai', 'Murano', 'Juke'],
  'Suzuki SUV': ['Vitara', 'Jimny', 'Grand Vitara', 'Escudo', 'SX4 S-Cross'],
  'Kia SUV': ['Sportage', 'Seltos', 'Soul', 'Telluride', 'Sorento'],
};
