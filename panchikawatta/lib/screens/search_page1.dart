import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/User/filter_sort.dart';
import 'package:panchikawatta/screens/User/services_list.dart';
import 'package:panchikawatta/screens/User/spareparts_list.dart';
import 'package:panchikawatta/services/filter_api_service.dart';
import 'package:panchikawatta/services/get_api_services.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:panchikawatta/screens/SignUp/sign_up1.dart';

import '../models/service.dart';

class search_page1 extends StatefulWidget {
  final List<SparePart> ads;
  const search_page1({super.key, required this.ads});

  @override
  State<search_page1> createState() => _SearchPage1State();
}

class _SearchPage1State extends State<search_page1> {
  late Future<List<SparePart>> _spareParts;
  late Future<List<Service>> _services;
  late Future<List<SparePart>> _searchedSpareParts;
  late Future<List<Service>> _searchedServices;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userProfile;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _spareParts = GetApiService().getSpareParts();
    _services = GetApiService().getServices();
    _userProfile = _getUserProfile();
    _userProfile.then((snapshot) {
      setState(() {
        userData = snapshot.data();
      });
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    throw Exception("No user logged in");
  }

  void _search() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _searchedSpareParts =
            GetApiService().searchSpareparts(_searchController.text);
        _searchedServices =
            GetApiService().searchServices(_searchController.text);
      } else {
        _spareParts = GetApiService().searchSpareparts('');
        _services = GetApiService().getServices();
      }
    });
  }

  void _sort(String sort) {
    setState(() {
      if (_isSearching) {
        _searchedSpareParts = FilterApiService().getSortedSpareParts(sort);
        _searchedServices = FilterApiService().getSortedServices(sort);
      } else {
        _spareParts = FilterApiService().getSortedSpareParts(sort);
        _services = FilterApiService().getSortedServices(sort);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_rounded, size: 30),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        elevation: 0,
        actions: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Buyer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffFF5C01),
                    ),
                  ),
                  Text(
                    userData?['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              CircleAvatar(
                radius: 25,
                backgroundImage: userData?['profile_picture'] != null
                    ? NetworkImage(userData!['profile_picture'])
                    : const AssetImage('assets/images/profile_image.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 5),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: const Text('Sign Out'),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, '/SplashScreen');
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Sign Up'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sign_up1()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const TabBar(
                    indicatorColor: Color(0xffFF5C01),
                    labelColor: Color(0xffFF5C01),
                    unselectedLabelColor: Colors.black,
                    labelStyle: TextStyle(fontSize: 15),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: 'Spareparts'),
                      Tab(text: 'Services'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFFF5C01),
                        size: 25,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFAFAFA),
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      hintText: "Search",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xffFAFAFA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xffFAFAFA)),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      _search();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'newest_first',
                            child: Text('Newest first (Default)'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'oldest',
                            child: Text('Oldest first'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'price_low_high',
                            child: Text('Price: Low to High'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'price_high_low',
                            child: Text('Price: High to Low'),
                          ),
                        ],
                        onSelected: (String value) {
                          _sort(value);
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.sort_rounded,
                              color: Color(0xffFF5C01),
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Sort by',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFF5C01),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FilterSortScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Filter results',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFF5C01),
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.grid_view_outlined,
                              color: Color(0xffFF5C01),
                              size: 23,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SparePartsList(
                    spareParts:
                        _isSearching ? _searchedSpareParts : _spareParts,
                  ),
                  ServicesList(
                    services: _isSearching ? _searchedServices : _services,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
