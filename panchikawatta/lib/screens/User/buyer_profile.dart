import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/models/vehicle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:panchikawatta/global/globals.dart' as globals;
import 'package:panchikawatta/screens/Order/buyer_order.dart';
import 'package:panchikawatta/screens/Order/wishlist.dart';

class BuyerProfile extends StatefulWidget {
  final String? email;

  BuyerProfile(this.email);

  @override
  _BuyerProfileState createState() => _BuyerProfileState();
}

class _BuyerProfileState extends State<BuyerProfile> {
  List<Vehicle> vehicles = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserIdByEmail();
  }

  Future<void> fetchUserIdByEmail() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/users/getidbyemail/${widget.email}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          globals.userId = data['userId'];
          print('User id: ${globals.userId}');
        });
        fetchVehicles(); // Once userId is fetched, fetch vehicles
      } else {
        throw Exception('Failed to load user ID');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  Future<void> fetchVehicles() async {
    if (globals.userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/users/getVehicles/${globals.userId}'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> decodedBody = json.decode(response.body);
          if (decodedBody.isEmpty) {
            setState(() {
              errorMessage = 'No vehicles found';
              vehicles = [];
            });
          } else {
            setState(() {
              vehicles =
                  decodedBody.map((json) => Vehicle.fromJson(json)).toList();
              errorMessage =
                  ''; // Clear the error message if vehicles are found
            });
          }
        } else {
          setState(() {
            errorMessage = 'No vehicles registered';
            vehicles = [];
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'An error occurred: $e';
          vehicles = [];
        });
      }
    } else {
      setState(() {
        errorMessage = 'User ID is null';
        vehicles = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1, // left
                0, // top
                MediaQuery.of(context).size.width * 0.1, // right
                0, // bottom
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onPressed: () {
                        print('Navigating to wishlist');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WishlistScreen(userId: globals.userId!)),
                        );
                      },
                      text: 'Wishlist',
                    ),
                    CustomButton(
                      onPressed: () {
                        print('Navigating to BuyerOrderScreen');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BuyerOrderScreen(userId: globals.userId!)),
                        );
                      },
                      text: 'Orders',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Divider(
                color: Color(0x80000000),
                thickness: 1,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.1, // left
                0, // top
                MediaQuery.of(context).size.width * 0.1, // right
                0, // bottom
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'My Vehicles',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      // Add your button press logic here
                    },
                    text: "Add Vehicle",
                  )
                ],
              ),
            ),
            if (errorMessage.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      errorMessage,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: vehicle.imageUrl.isNotEmpty
                          ? Image.network(
                              vehicle.imageUrl,
                              width: 70,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported, size: 50),
                      title: Text(
                        '${vehicle.make} ${vehicle.model}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Year: ${vehicle.year}',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            vehicle.nearestReminder != null
                                ? vehicle.nearestReminder!.type
                                : 'Not set',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 105, 104, 104),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}