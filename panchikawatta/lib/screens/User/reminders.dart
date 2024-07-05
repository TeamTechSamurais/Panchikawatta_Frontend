// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    try {
      final vehiclesData =
          await getUserVehicleReminders(2); // Replace 1 with the actual userId
      setState(() {
        vehicles = vehiclesData;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  Future<void> markAsDone(int vehicleId) async {
    final response = await http
        .patch(Uri.parse('http://10.0.2.2:8000/api/reminders/$vehicleId/done'));
    if (response.statusCode == 200) {
      fetchVehicles(); // Refresh the list after marking as done
    } else {
      throw Exception('Failed to update reminder');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Color(0xFFFF5C01),
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        itemCount: vehicles.length,
        itemBuilder: (ctx, i) => VehicleItem(
          vehicleId: vehicles[i]['vehicleId'],
          make: vehicles[i]['make'],
          model: vehicles[i]['model'],
          year: vehicles[i]['year'].toString(),
          nearestReminder: vehicles[i]['nearestReminder']['type'] +
              ' - ' +
              vehicles[i]['nearestReminder']['date'],
          onMarkAsDone: markAsDone,
        ),
      ),
    );
  }
}

class VehicleItem extends StatelessWidget {
  final int vehicleId;
  final String make;
  final String model;
  final String year;
  final String nearestReminder;
  final Function(int) onMarkAsDone;

  const VehicleItem({
    super.key,
    required this.vehicleId,
    required this.make,
    required this.model,
    required this.year,
    required this.nearestReminder,
    required this.onMarkAsDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$make $model $year',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      nearestReminder,
                      style: const TextStyle(
                        color: Color(0xFFFF5C01),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/car_image.png', // Use the correct path to your image asset
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5C01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => onMarkAsDone(vehicleId),
              child: const Text(
                'Mark As Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getUserVehicleReminders(int userId) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:8000/users/getReminder/$userId'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load vehicle reminders');
  }
}
