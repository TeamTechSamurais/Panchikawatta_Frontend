import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/Order/buy_it_now.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/chat_room.dart';
import 'package:panchikawatta/services/get_api_services.dart';
import 'package:panchikawatta/services/post_api_service.dart';
import 'package:panchikawatta/models/sparepart.dart' as model;
import 'package:card_swiper/card_swiper.dart';

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
  int? get userId => 2;
  final _firestore = FirebaseFirestore.instance;
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
            child: const Icon(
              Icons.favorite_outline,
              size: 30,
              color: Color(0xFFFF5C01),
            ),
          ),
          const SizedBox(width: 30)
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
                      height: 300,
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
                        pagination: SwiperPagination(),
                        control: SwiperControl(),
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
                              builder: (context) => BuyNowScreen()),
                        );
                      },
                      text: 'Buy it Now',
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        sparePart.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
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
                          color: Colors.black,
                        ),
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
                          );

                          // Navigate to the chat room
                          Navigator.of(context).push(
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
                            TextDetail(title: 'Make:', value: sparePart.make),
                            TextDetail(title: 'Model:', value: sparePart.model),
                            TextDetail(
                              title: 'Year:',
                              value: sparePart.year.toString(),
                            ),
                            TextDetail(
                              title: 'Condition:',
                              value: sparePart.condition,
                            ),
                            TextDetail(title: 'Fuel:', value: sparePart.fuel),
                            TextDetail(
                                title: 'Origin:', value: sparePart.origin),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            const Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                sparePart.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
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

  Widget TextDetail({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 87, 87, 87),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
