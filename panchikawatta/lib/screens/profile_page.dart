import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/screens/Profile/buyer_profile.dart';
import 'package:panchikawatta/screens/api_service.dart';
import 'package:panchikawatta/screens/delete_and_edit_my_profile.dart';
import 'package:panchikawatta/screens/edit_profile_page.dart';
import 'package:panchikawatta/screens/seller_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<Map<String, dynamic>>? _userFuture;
  String? profilePictureUrl;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSeller = false;
  int? _userId;
  String? _email;
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _businessAddress = TextEditingController();
  final TextEditingController _businessPhone = TextEditingController();
  final TextEditingController _businessDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _fetchUser();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
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
      final userId = user['id'];

      setState(() {
        _userFuture = Future.value(user);
        _userId = userId;

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          if (doc['profile_picture'] != null) {
            profilePictureUrl = doc['profile_picture'];
          } else {
            profilePictureUrl = null;
          }

          if (userId != null) {
            _fetchSellerStatus(userId);
          }
        }
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
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  Future<void> _fetchSellerStatus(int userId) async {
    final sellerData = await ApiServices.getSellerById(userId);
    bool isSeller = false;

    if (sellerData != null &&
        (!sellerData.containsKey('status') ||
            sellerData['status'] != 'error')) {
      isSeller = true;
    }

    setState(() {
      _isSeller = isSeller;
    });
  }

  void _handleTabChange() {
    if (_tabController.index == 1 && !_isSeller && _userId != null) {
      Future.delayed(Duration.zero, () {
        final formKey = GlobalKey<FormState>();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width * 0.98,
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Fill your Profile",
                      style: TextStyle(
                        color: Color(0xFFFF5C01),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          InputFields(
                            hintText: "Business Name",
                            width1: MediaQuery.of(context).size.width * 0.8,
                            controller: _businessName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a business name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          InputFields(
                            hintText: "Business Address",
                            width1: MediaQuery.of(context).size.width * 0.8,
                            controller: _businessAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a business address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          InputFields(
                            hintText: "Phone (+94)",
                            width1: MediaQuery.of(context).size.width * 0.8,
                            controller: _businessPhone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              // Check if the phone number is valid
                              final phoneRegExp = RegExp(r'^\d{10}$');
                              if (!phoneRegExp.hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          InputFields(
                            hintText: "Business description",
                            width1: MediaQuery.of(context).size.width * 0.8,
                            controller: _businessDescription,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a business description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Handle form submission
                                final data = {
                                  'business_name': _businessName.text,
                                  'business_address': _businessAddress.text,
                                  'business_phone': _businessPhone.text,
                                  'business_description':
                                      _businessDescription.text,
                                  'user_id': _userId,
                                };
                                ApiServices.registerSeller(data);
                              }
                            },
                            text: 'submit',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).then((_) {
          _tabController.index =
              0; // Switch back to the buyer tab when the dialog is closed
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: const Text('My Profile',
              style: TextStyle(
                  color: Color(0xFFFF5C01),
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings, color: Colors.black, size: 28),
              onSelected: (String result) {
                switch (result) {
                  case 'EditProfile':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
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
                  child: Text('Logout',
                      style: TextStyle(color: Color(0xFFFF5C01))),
                ),
              ],
            ),
          ],
        ),
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
                          radius: 60,
                          backgroundImage: profilePictureUrl != null
                              ? NetworkImage(profilePictureUrl!)
                              : null,
                          child: profilePictureUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                )
                              : null),
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: Text(
                      '${user['userName']}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    )),
                    const SizedBox(height: 10),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        _individualTab(
                          'Buyer',
                        ),
                        _individualTab('Seller'),
                      ],
                      labelColor: const Color(0xFFFF5C01),
                      unselectedLabelColor: const Color(0x80000000),
                      indicatorColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.all(0),
                      indicatorPadding: const EdgeInsets.all(0),
                      dividerColor: Colors.transparent,
                    ),
                    Container(
                      height: 1500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          BuyerProfile(_email),
                          _isSeller ? SellerProfile() : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            }
          },
        ));
  }

  //A method to create an individual tab. This is created to add a vertical divider between the tabs.
  Widget _individualTab(String text) {
    return Container(
      height: 50 + MediaQuery.of(context).padding.bottom,
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: Color(0x80000000),
                  width: 0,
                  style: BorderStyle.solid))),
      child: Tab(
        text: text,
      ),
    );
  }
}
