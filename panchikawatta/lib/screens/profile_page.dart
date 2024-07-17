import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/global/common/toast.dart';
import 'package:panchikawatta/screens/Profile/buyer_profile.dart';
import 'package:panchikawatta/screens/Profile/edit_seller_profile.dart';
import 'package:panchikawatta/services/api_service.dart';
import 'package:panchikawatta/screens/Profile/delete_and_edit_my_profile.dart';
import 'package:panchikawatta/screens/edit_profile_page.dart';
import 'package:panchikawatta/screens/Profile/seller_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:panchikawatta/global/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Future<Map<String, dynamic>>? _userFuture;
  String? profilePictureUrl;
  bool _isSeller = false;
  int? _userId = globals.userId;
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

  Future<void> _fetchSellerStatus(int userId) async {
    final sellerData = await ApiServices.getSellerById(userId);
    bool isSeller = false;

    if ((!sellerData.containsKey('status') ||
        sellerData['status'] != 'error')) {
      isSeller = true;
    }

    setState(() {
      _isSeller = isSeller;
    });
  }

  Future<void> _fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email != null) {
      final user = await ApiServices.getUserByEmail(email);
      final userId = user['id'];

      setState(() {
        _userId = userId;
        _userId = globals.userId;

        if (userId != null) {
          _fetchSellerStatus(userId);
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
                  child: const Text('Sign Up',
                      style: TextStyle(color: Color(0xFFFF5C01))),
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 1 && !_isSeller && _userId != null) {
      Future.delayed(Duration.zero, () {
        final formKey = GlobalKey<FormState>();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width * 0.98,
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
                          TextFormField(
                            controller: _businessDescription,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Business Description',
                              filled: true,
                              fillColor: Color.fromARGB(255, 241, 239, 237),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a business description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                // Handle form submission
                                final data = {
                                  'businessName': _businessName.text,
                                  'businessAddress': _businessAddress.text,
                                  'businessPhoneNo': _businessPhone.text,
                                  'businessDescription':
                                      _businessDescription.text,
                                  'userId': _userId,
                                };

                                try {
                                  final response =
                                      await ApiServices.registerSeller(data);

                                  if (response['status'] != 'error') {
                                    setState(() {
                                      _isSeller = true;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SellerProfile(
                                          userId: _userId!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show error message
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(content: Text(response['message'])),
                                    // );
                                    showToast(message: response['message']);
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  // Handle any errors that might have occurred during the request
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'An unexpected error occurred')),
                                  );
                                  Navigator.of(context).pop();
                                }
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
            ));
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
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings, color: Colors.black, size: 28),
              onSelected: (String result) {
                switch (result) {
                  case 'EditBuyerProfile':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                    break;
                  case 'EditSellerProfile':
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditSellerProfile(userId: _userId!);
                      },
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
                  value: 'EditBuyerProfile',
                  child: Text('Edit Buyer Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'EditSellerProfile',
                  child: Text('Edit Seller Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'DeleteProfile',
                  child: Text('Delete Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: Color(0xffFF5C01),
            labelColor: Color(0xffFF5C01),
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15),
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
            tabs: [Tab(text: 'Buyer'), Tab(text: 'Seller')],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 1500,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BuyerProfile(),
                    _isSeller
                        ? SellerProfile(
                            userId: _userId!,
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
