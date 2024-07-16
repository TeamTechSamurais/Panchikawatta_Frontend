import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/chat_room.dart';
import 'package:panchikawatta/services/get_api_services.dart';

class ServiceScreen extends StatefulWidget {
  final int serviceId;

  ServiceScreen({super.key, required this.serviceId});

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

  String chatRoomId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return users.join("");
  }

  @override
  void initState() {
    super.initState();
    print('ServiceScreen serviceId: ${widget.serviceId}');
    futureService = GetApiService().getServiceById(widget.serviceId);
  }

  Future<void> _fetchUser(int sellerId) async {
    final Map<String, dynamic> seller = await ApiServices.getUserById(sellerId);
    final sellerEmail = seller['email'];

    final querySnapshot = await _firestore
        .collection('user')
        .where('email', isEqualTo: sellerEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;

      setState(() {
        otherUserId = doc['uid'];
        userDisplayName = doc['displayName'];
        userDisplayPicture = doc['photoUrl'];
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
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.black,
          ),
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
        actions: const [],
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
              padding: EdgeInsets.symmetric(
                  horizontal: _padding), // Apply common padding
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Swiper(
                        itemCount: service.imageUrls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            service.imageUrls[index],
                            fit: BoxFit.contain,
                          );
                        },
                        pagination: SwiperPagination(),
                        control: SwiperControl(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rs. ${service.price}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 100),
                      GestureDetector(
                        onTap: () {
                          // Add code to call the phone number here
                        },
                        child: const Icon(
                          Icons.local_phone_rounded,
                          color: Color(0xFFFF5C01),
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          final sellerId = service.id;

                          await _fetchUser(sellerId);

                          String roomId = chatRoomId(
                            _auth.currentUser!.uid,
                            otherUserId,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: {
                                  'uid': otherUserId,
                                  'name': userDisplayName,
                                  'profile_picture': userDisplayPicture
                                },
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.mail_rounded,
                          color: Color(0xFFFF5C01),
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFF5C01)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              service.description,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
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
