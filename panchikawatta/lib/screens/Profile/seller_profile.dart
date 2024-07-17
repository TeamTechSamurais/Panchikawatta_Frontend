import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/global/common/toast.dart';
import 'package:panchikawatta/screens/AdPost/adType.dart';
import 'package:panchikawatta/screens/Order/seller_order.dart';
import 'package:panchikawatta/screens/Profile/services_ads.dart';
import 'package:panchikawatta/screens/Profile/spare_parts_ads.dart';
import 'package:panchikawatta/services/api_service.dart';

class SellerProfile extends StatefulWidget {
  final int userId;

  SellerProfile({required this.userId});

  @override
  _SellerProfile createState() => _SellerProfile();
}

class _SellerProfile extends State<SellerProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _seller;
  final _firestore = FirebaseFirestore.instance;
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchSeller();
  }

  void fetchSeller() async {
    try {
      final sellerData = await ApiServices.getSellerById(widget.userId);

      final user = await ApiServices.getUserById(widget.userId);
      final userEmail = user['email'];

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      setState(() {
        _seller = sellerData;

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          if (doc['profile_picture'] != null) {
            profilePictureUrl = doc['profile_picture'];
          } else {
            profilePictureUrl = null;
          }
        }
      });
    } catch (e) {
      print('Error fetching seller data: $e');
      showToast(message: 'An error occurred while fetching seller data.');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _seller == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: profilePictureUrl != null
                                  ? NetworkImage(profilePictureUrl!)
                                  : null,
                              child: profilePictureUrl == null
                                  ? const Icon(Icons.person, size: 60)
                                  : null),
                        ),
                        const SizedBox(width: 10),
                        Center(
                            child: Text(
                          _seller!['businessName'],
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color(0xFFFF5C01),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                    _seller!['businessDescription'],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  )),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.black),
                        Text(
                          _seller!['businessAddress'],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, color: Colors.black),
                        Text(
                          _seller!['businessPhoneNo'],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AdType()),
                              );
                            },
                            text: 'Post ad'),
                        CustomButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SellerOrderScreen(
                                          userId: widget.userId,
                                        )),
                              );
                            },
                            text: 'View Orders'),
                      ],
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
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('My Ads',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0x80FF5C01),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                tabs: const [
                                  Tab(text: 'Spare Parts'),
                                  Tab(text: 'Services'),
                                ],
                                dividerColor: Colors.transparent,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color(0xFFFF55C01),
                                ),
                                indicatorColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.tab,
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Container(
                    height: 2000, // You can adjust this value as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SparePartsAds(),
                        ServicesAds(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
