import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/vehicle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:panchikawatta/global/globals.dart' as globals;
import 'package:panchikawatta/screens/Order/buyer_order.dart';
import 'package:panchikawatta/screens/Order/wishlist.dart';
import 'package:panchikawatta/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerProfile extends StatefulWidget {
  @override
  _BuyerProfileState createState() => _BuyerProfileState();
}

class _BuyerProfileState extends State<BuyerProfile> {
  List<Vehicle> vehicles = [];
  String? _email;
  String? profilePictureUrl;
  Future<Map<String, dynamic>>? _userFuture;
  final _firestore = FirebaseFirestore.instance;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email != null) {
      setState(() {
        _email = email;
      });

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      final user = await ApiServices.getUserByEmail(email);

      setState(() {
        _userFuture = Future.value(user);

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          if (doc['profile_picture'] != null) {
            profilePictureUrl = doc['profile_picture'];
          } else {
            profilePictureUrl = null;
          }
        }

        globals.userId = user['id']; // Assign user ID to globals.userId
        fetchVehicles(globals.userId!); // Fetch vehicles with the user ID
      });
    } else {
      // Handle the case where the email is not found
      return showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
              content:
                  const Text('You do not have an account. Please sign up.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sign Up',
                      style: TextStyle(color: Color(0xFFFF5C01))),
                ),
              ],
            );
          });
    }
  }

  Future<void> fetchVehicles(int userId) async {
    try {
      print('User ID: $userId');
      final response = await http.get(
        Uri.parse('${Utils.baseUrl}/users/getVehicles/$userId'),
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
            errorMessage = ''; // Clear the error message if vehicles are found
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (_userFuture == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF5C01),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                        radius: 60,
                        backgroundImage: profilePictureUrl != null
                            ? NetworkImage(profilePictureUrl!)
                            : null,
                        child: profilePictureUrl == null
                            ? const Icon(Icons.person, size: 60)
                            : null),
                  ),
                  const SizedBox(height: 10),
                  Center(
                      child: Text('${user['userName']}',
                          style: const TextStyle(fontSize: 18))),
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
                                    builder: (context) => WishlistScreen(
                                        userId: globals.userId!)),
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
                                    builder: (context) => BuyerOrderScreen(
                                          userId: globals.userId!,
                                        )),
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
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
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
                          const SizedBox(height: 30),
                          Text(
                            errorMessage,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
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
                                : const Icon(Icons.image_not_supported,
                                    size: 50),
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
                                      : 'No reminders',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
