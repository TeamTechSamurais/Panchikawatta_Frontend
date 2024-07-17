import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:panchikawatta/services/api_service.dart';
import 'package:panchikawatta/screens/chat_room.dart';
import 'package:panchikawatta/services/get_api_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceScreen extends StatefulWidget {
  final int serviceId;

  const ServiceScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late Future<Service> futureService;
  final double _padding = 20.0; // Define common padding value
  final _firestore = FirebaseFirestore.instance;
  late String otherUserId = '';
  late String userDisplayName = '';
  late String? userDisplayPicture = '';
  final _auth = FirebaseAuth.instance;

  // String chatRoomId(String user1, String user2) {
  //   List<String> users = [user1, user2];
  //   users.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  //   return users.join("");
  // }
  String chatRoomId(String user1, String user2, int sparePartId) {
    // Create a list with user1 and user2
    List<String> users = [user1, user2];

    // Sort the list to ensure a consistent order
    users.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    // Add the sparePartId to the end of the list as a string
    users.add(sparePartId.toString());

    // Join the elements to form the chatRoomId
    return users.join("_");
  }

  @override
  void initState() {
    super.initState();
    print('ServiceScreen serviceId: ${widget.serviceId}');
    futureService = GetApiService().getServiceById(widget.serviceId);
  }

  Future<void> _fetchUser(int sellerId) async {
    print('Seller ID: $sellerId');
    final Map<String, dynamic> seller = await ApiServices.getUserById(sellerId);
    final sellerEmail = seller['email'];

    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: sellerEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;

      setState(() {
        otherUserId = doc.id;
        userDisplayName = doc['name'];
        userDisplayPicture = doc['profile_picture'];
      });
    } else {
      print('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_rounded,
              size: 30, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Details",
          style: TextStyle(
              color: Color(0xFFFF5C01),
              fontSize: 28,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<Service>(
        future: futureService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Service not found'));
          } else {
            var service = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: _padding),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      height: 270,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Image.network(
                        service.imageUrls.isNotEmpty
                            ? service.imageUrls[0]
                            : 'placeholder_image_url',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, thickness: 1.5),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 30),
                      Text(
                        'Rs. ${service.price}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 100),
                      GestureDetector(
                        onTap: () async {
                          try {
                            String businessPhoneNo = await GetApiService()
                                .getBusinessPhoneNo(service.sellerId);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Call',
                                      style: TextStyle(
                                          color: Color(0xFFFF5C01),
                                          fontWeight: FontWeight.bold)),
                                  content: Text(businessPhoneNo,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              color: Color(0xFFFF5C01))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Call',
                                          style: TextStyle(
                                              color: Color(0xFFFF5C01))),
                                      onPressed: () async {
                                        final url = 'tel:$businessPhoneNo';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            print('Error fetching business phone number: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error fetching phone number: $e')),
                            );
                          }
                        },
                        child: const Icon(Icons.call_rounded,
                            color: Color(0xFFFF5C01), size: 35),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          final sellerId = service.id;

                          await _fetchUser(sellerId);

                          String roomId = chatRoomId(
                            _auth.currentUser!.uid,
                            otherUserId,
                            service.id,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: {
                                  'uid': otherUserId,
                                  'name': userDisplayName,
                                  'profile_picture': userDisplayPicture,
                                  'title': service.title,
                                  'sparePartId': service.id,
                                },
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.mail_rounded,
                            color: Color(0xFFFF5C01), size: 35),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const Divider(color: Colors.grey, thickness: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(
                                  color: Color(0xFFFF5C01),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              service.description,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
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
