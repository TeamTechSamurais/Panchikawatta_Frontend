import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/User/wishlist.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/chat_room.dart';
import 'package:panchikawatta/services/get_api_services.dart';

class BuyScreen extends StatefulWidget {
  final int sparePartId;

  const BuyScreen({super.key, required this.sparePartId});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late Future<SparePart> futureSparePart;
  final double _padding = 20.0; // Define common padding value
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String otherUserId = '';
  late String userDisplayName = '';
  late String? userDisplayPicture = '';

  String chatRoomId(String user1, String user2) {
    List<String> users = [user1, user2];
    users.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return users.join("");
  }

  @override
  void initState() {
    super.initState();

    // Verify the ID received
    print('Received Sparepart ID in BuyScreen: ${widget.sparePartId}');

    // Fetch the spare part using the received ID
    futureSparePart = GetApiService().getSparePartById(widget.sparePartId);
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },
            child: const Icon(
              Icons.favorite_outline,
              size: 30,
              color: Color(0xFFFF5C01),
            ),
          ),
          const SizedBox(width: 30)
        ],
      ),
      body: FutureBuilder<SparePart>(
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
                      child: sparePart.imageUrls.isNotEmpty
                          ? Image.network(
                              sparePart.imageUrls[0],
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              'assets/images/no_image.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: CustomButton(
                      onPressed: () {
                        // Add your buy logic here
                      },
                      text: '              Buy it Now              ',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey, thickness: 1.5),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rs. ${sparePart.price}',
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
                          final sellerId = sparePart
                              .sellerId; // Get the seller ID from the spare part table
                          await _fetchUser(
                              sellerId); // Fetch the user ID from the firestore

                          // Generate chat room ID
                          String roomId = chatRoomId(
                            _auth.currentUser!.uid,
                            otherUserId,
                          );

                          // Navigate to the chat room
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: {
                                      'uid': otherUserId,
                                      'name': userDisplayName,
                                      'profile_picture': userDisplayPicture
                                    },
                                  )));
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
                            const Divider(color: Colors.grey, thickness: 1),
                            Center(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 180),
                                child: Table(
                                  columnWidths: const {
                                    0: FixedColumnWidth(100.0),
                                    1: FlexColumnWidth(),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text('Title:'),
                                        ),
                                        Text(sparePart.title),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text('Price:'),
                                        ),
                                        Text('Rs. ${sparePart.price}'),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text('Description:'),
                                        ),
                                        Text(sparePart.description),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text('Seller ID:'),
                                        ),
                                        Text('${sparePart.sellerId}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
