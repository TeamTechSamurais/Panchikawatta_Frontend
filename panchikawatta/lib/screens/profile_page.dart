  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/Profile/buyer_profile.dart';
import 'package:panchikawatta/screens/Profile/edit_profile_page.dart';

import 'package:panchikawatta/screens/delete_and_edit_my_profile.dart';
 
import 'package:panchikawatta/screens/seller_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userProfile = _getUserProfile();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    throw Exception("No user logged in");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('My Profile', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.black, size: 28),
            onSelected: (String result) {
              switch (result) {
                case 'EditProfile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                  break;
                case 'DeleteProfile':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteProfileDialog();
                    },
                  );
                  break;
                case 'Logout':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Logout();
                    },
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'EditProfile',
                child: Text('Edit Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'DeleteProfile',
                child: Text('Delete Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout', style: TextStyle(color: Color(0xFFFF5C01))),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var userData = snapshot.data!.data();
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: userData?['profile_picture'] != null
                          ? NetworkImage(userData!['profile_picture'])
                          : AssetImage('lib/assets/profilePicture.jpg') as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Text(userData?['name'] ?? 'No Username', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 25),
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      _individualTab('Buyer'),
                      _individualTab('Seller'),
                    ],
                    labelColor: Color(0xFFFF5C01),
                    unselectedLabelColor: Color(0x80000000),
                    indicatorColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.all(0),
                    indicatorPadding: EdgeInsets.all(0),
                    dividerColor: Colors.transparent,
                  ),
                  Container(
                    height: 2000,  
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BuyerProfile(),
                        SellerProfile(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return Center(child: Text("No user data available"));
          }
        },
      ),
    );
  }

  Widget _individualTab(String text) {
    return Container(
      height: 50 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.all(0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Color(0x80000000), width: 0, style: BorderStyle.solid)),
      ),
      child: Tab(text: text),
    );
  }
}
