// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'dart:convert';
import 'package:panchikawatta/global/globals.dart' as globals;
import 'package:panchikawatta/models/vehicle.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Vehicle> vehicles = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (globals.userId != null) {
      fetchReminders(globals.userId!); // Fetch vehicles with the user ID
    } else {
      setState(() {
        errorMessage = 'User ID is null';
        vehicles = [];
      });
    }
  }

  Future<void> fetchReminders(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/users/getReminder/$userId'));

      if (response.statusCode == 200) {
        setState(() {
          vehicles = (json.decode(response.body) as List)
              .map((data) => Vehicle.fromJson(data))
              .toList();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load vehicles';
          vehicles = [];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        vehicles = [];
      });
    }
  }

  Future<void> markAsDone(int vehicleId, String reminderType) async {
    try {
      final response = await http.delete(Uri.parse(
          '${Utils.baseUrl}/users/markAsDone/$vehicleId/$reminderType'));

      if (response.statusCode == 200) {
        fetchReminders(globals.userId!); // Refresh the list after deletion
      } else {
        throw Exception('Failed to delete reminder');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Color(0xFFFF5C01),
          ),
        ),
      ),
      body: errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3 / 1,
                mainAxisSpacing: 10,
              ),
              itemCount: vehicles.length,
              itemBuilder: (ctx, i) => VehicleItem(
                vehicleId: vehicles[i].vehicleId,
                make: vehicles[i].make,
                model: vehicles[i].model,
                year: vehicles[i].year.toString(),
                nearestReminder: vehicles[i].nearestReminder != null
                    ? '${vehicles[i].nearestReminder!.type}: ${vehicles[i].nearestReminder!.date}'
                    : 'No reminders',
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
  final Function(int, String) onMarkAsDone;

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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                const Icon(Icons.car_crash_outlined, size: 50),
                const SizedBox(width: 20),
                Text('$make $model $year',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            Text('Reminder: $nearestReminder',
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 26, 10), fontSize: 16)),
            ElevatedButton(
              onPressed: () => onMarkAsDone(vehicleId, nearestReminder),
              child: const Text('Mark as Done'),
            ),
          ],
        ),
      ),
    );
  }
}
