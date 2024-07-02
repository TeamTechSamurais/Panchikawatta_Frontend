import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/buyer_profile.dart';
import 'package:panchikawatta/screens/delete_and_edit_my_profile.dart';
import 'package:panchikawatta/screens/edit_profile_page.dart';
import 'package:panchikawatta/screens/seller_profile.dart';
import 'package:panchikawatta/screens/sign_up2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  Future<Map<String, dynamic>>? _user;
  Future<Map<String, dynamic>>? seller;
  String? profilePictureUrl;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSeller = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email != null) {
      final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

      setState(() {
        _user = ApiServices.getUserByEmail(email);

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          if (doc['profile_picture'] != null) {
            profilePictureUrl = doc['profile_picture']; 
          } else {
            profilePictureUrl = null;
          }

          _fetchSellerStatus(doc['id']);
            
        }
      });

    } else {
      // Handle the case where the email is not found
      return showDialog(
        context: context, 
        builder: (BuildContext) {
          return AlertDialog(
            content: const Text('You do not have an account. Please sign up.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),

            ],
          );
        }
      );
    }
  }

  Future<void> _fetchSellerStatus(int userId) async {
    final sellerData = await ApiServices.getSellerById(userId);
    bool isSeller = false;

    if (sellerData != null && (!sellerData.containsKey('status') || sellerData['status'] != 'error')) {
      isSeller = true;
    }

    setState(() {
      _isSeller = isSeller;
    });
  }

  // void fetchSeller(AboutDialog) {
  //   // Fetch the seller's data from the database
  //   _seller =  ApiServices.getSellerById(userId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text('My Profile', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28, fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.black, size: 28),
            onSelected: (String result) {
              switch (result) {
                case 'EditProfile':
                  // Handle action for EditProfile
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
                  // Handle your action for Logout
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

      body: FutureBuilder<Map<String, dynamic>>(
        future: _user,
        builder: (context, snapshot) {
          if (_user == null) {
            return const Center(
              child: CircularProgressIndicator( color: Color(0xFFFF5C01),),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5C01)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: profilePictureUrl != null ? NetworkImage(profilePictureUrl!) : null,
                      child: profilePictureUrl == null ? const Icon(Icons.person, size: 80,) : null
                    ),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: Text('${user['userName']}', style: const TextStyle(fontSize: 18,),)
                  ),

                  const SizedBox(height: 25),

                  TabBar(
                    controller: _tabController,
                    tabs: [
                        _individualTab('Buyer',),
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
                    height: 2000, // You can adjust this value as needed
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BuyerProfile(),

                        _isSeller? SellerProfile() : sign_up2(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                ],
              ),
            );
          }
        },
      )
    );
  }

  
  
  //A method to create an individual tab. This is created to add a vertical divider between the tabs.
  Widget _individualTab(String text) {
    return Container(
        height: 50 + MediaQuery
          .of(context)
          .padding
          .bottom,
        padding: EdgeInsets.all(0),
        width: double.infinity,
        decoration:  BoxDecoration(border: Border(right: BorderSide(color: Color(0x80000000), width: 0, style: BorderStyle.solid))),
        child: Tab(
            text: text,
        ),
    );
  }

}