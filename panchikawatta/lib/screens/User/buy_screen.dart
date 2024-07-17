// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/Order/buy_it_now.dart';
import 'package:panchikawatta/screens/chat_room.dart';
import 'package:panchikawatta/services/api_service.dart';
import 'package:panchikawatta/services/get_api_services.dart';
import 'package:panchikawatta/services/post_api_service.dart';
import 'package:panchikawatta/models/sparepart.dart' as model;
import 'package:card_swiper/card_swiper.dart';
import 'package:panchikawatta/global/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class BuyScreen extends StatefulWidget {
  final int sparePartId;

  const BuyScreen({Key? key, required this.sparePartId}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late Future<model.SparePart> futureSparePart;
  final double _padding = 20.0;
  final GetApiService getApiService = GetApiService();
  final PostApiService postApiService = PostApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  int? get userId => globals.userId;
  final _firestore = FirebaseFirestore.instance;
  late String otherUserId = '';
  late String userDisplayName = '';
  late String? userDisplayPicture = '';

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

    // Verify the ID received
    print('Received Sparepart ID in BuyScreen: ${widget.sparePartId}');
    print('User Id $userId');

    // Fetch the spare part using the received ID
    futureSparePart = getApiService.getSparePartById(widget.sparePartId);
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

  String formatPhoneNo(String phoneNo) {
    return phoneNo.length == 10
        ? '(${phoneNo.substring(0, 3)}) ${phoneNo.substring(3, 6)}-${phoneNo.substring(6)}'
        : phoneNo;
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
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                await postApiService.addToFavorites(
                    userId!, widget.sparePartId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add to favorites: $e')),
                  );
                }
              }
            },
            child: const Icon(Icons.favorite_outline,
                size: 30, color: Color(0xFFFF5C01)),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: FutureBuilder<model.SparePart>(
        future: futureSparePart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Spare part not found'));
          } else {
            var sparePart = snapshot.data!;
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
                      child: Swiper(
                        itemCount: sparePart.imageUrls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            sparePart.imageUrls[index],
                            fit: BoxFit.contain,
                          );
                        },
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuyNowScreen(
                              userId: userId!,
                              sparePartId: widget.sparePartId,
                            ),
                          ),
                        );
                      },
                      text: 'Buy it Now',
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 1.5),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sparePart.title,
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
                        'Rs. ${sparePart.price}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 100),
                      GestureDetector(
                        onTap: () async {
                          final sellerId = sparePart
                              .sellerId; // Get the seller ID from the spare part table
                          await _fetchUser(
                              sellerId); // Fetch the user ID from the firestore

                          // Generate chat room ID
                          String roomId = chatRoomId(
                            _auth.currentUser!.uid,
                            otherUserId,
                            sparePart.id,
                          );

                          // Navigate to the chat room
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: {
                                  'uid': otherUserId,
                                  'name': userDisplayName,
                                  'title': sparePart.title,
                                  'profile_picture': userDisplayPicture,
                                  'sparePartId': sparePart.id,
                                },
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.mail_rounded,
                            color: Color(0xFFFF5C01), size: 35),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          try {
                            String businessPhoneNo = await getApiService
                                .getBusinessPhoneNo(sparePart.sellerId);

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
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20)),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                            color: Color(0xFFFF5C01),
                                          )),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Call',
                                          style: TextStyle(
                                            color: Color(0xFFFF5C01),
                                          )),
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
                            Center(
                                child: Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(130),
                                  1: FixedColumnWidth(150)
                                },
                                children: [
                                  _buildTableRow(Icons.directions_car, 'Make',
                                      sparePart.make),
                                  const TableRow(children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10)
                                  ]),
                                  _buildTableRow(
                                      Icons.build, 'Model', sparePart.model),
                                  const TableRow(children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10)
                                  ]),
                                  _buildTableRow(Icons.calendar_today, 'Year',
                                      sparePart.year.toString()),
                                  const TableRow(children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10)
                                  ]),
                                  _buildTableRow(Icons.fact_check, 'Condition',
                                      sparePart.condition),
                                  const TableRow(children: [
                                    SizedBox(height: 10),
                                    SizedBox(height: 10)
                                  ]),
                                  _buildTableRow(Icons.location_on_rounded,
                                      'Origin', sparePart.origin),
                                ],
                              ),
                            )),
                            const Divider(color: Colors.grey, thickness: 1),
                            const Text(
                              "Description",
                              style: TextStyle(
                                  color: Color(0xFFFF5C01),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              sparePart.description,
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

  TableRow _buildTableRow(IconData icon, String label, String value) {
    return TableRow(
      children: [
        Row(
          children: [
            Icon(icon,
                color: const Color.fromARGB(255, 255, 152, 96), size: 20),
            const SizedBox(width: 15),
            Text(label,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.black, fontSize: 17)),
      ],
    );
  }
}
