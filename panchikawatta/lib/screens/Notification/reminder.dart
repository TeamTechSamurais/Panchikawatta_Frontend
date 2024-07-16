// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/vehicle.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late Future<List<Vehicle>> futureReminders;

  @override
  void initState() {
    super.initState();
    futureReminders = getUserVehicleReminders(1); // Provide the userId
  }

  Future<List<Vehicle>> getUserVehicleReminders(int userId) async {
    final response = await http.get(
      Uri.parse('${Utils.baseUrl}/users/getReminder/$userId'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Vehicle> vehicles =
          data.map((json) => Vehicle.fromJson(json)).toList();
      return vehicles;
    } else {
      throw Exception('Failed to load vehicle reminders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Vehicle>>(
        future: futureReminders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reminders available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var vehicle = snapshot.data![index];
                return ReminderCard(vehicle: vehicle);
              },
            );
          }
        },
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final Vehicle vehicle;

  const ReminderCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.make} ${vehicle.model} ${vehicle.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (vehicle.nearestReminder != null) ...[
                        Text(
                          vehicle.nearestReminder!.type,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          vehicle.nearestReminder!.date,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  children: [
                    Image.network(
                      vehicle.imageUrl.isNotEmpty
                          ? vehicle.imageUrl
                          : 'https://via.placeholder.com/150',
                      width: 110,
                      height: 110,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Mark as Done',
                  onPressed: () async {
                    try {
                      await markAsDone(
                          vehicle.id, vehicle.nearestReminder!.type);
                      // Optionally refresh the reminders list
                      // You can choose to refresh or update the list after marking as done
                      //  setState(() {
                      //    futureReminders = getUserVehicleReminders(20); // Provide the userId
                      //  });
                    } catch (error) {
                      print('Failed to mark reminder as done: $error');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// API to mark as done
Future<void> markAsDone(int vehicleId, String reminderType) async {
  final response = await http.delete(
    Uri.parse('${Utils.baseUrl}/vehicles/markAsDone/$vehicleId/$reminderType'),
  );
  if (response.statusCode == 200) {
    print('Reminder marked as done successfully');
  } else {
    throw Exception('Failed to mark reminder as done');
  }
}
