import 'package:flutter/material.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/components/input_fields.dart';
import 'package:panchikawatta/global/common/toast.dart';
import 'package:panchikawatta/services/api_service.dart';
import 'package:panchikawatta/screens/profile_page.dart';

class EditSellerProfile extends StatefulWidget {
  final int userId;

  EditSellerProfile({required this.userId});

  @override
  State<EditSellerProfile> createState() => _EditSellerProfileState();
}

class _EditSellerProfileState extends State<EditSellerProfile> {
  late Map<String, dynamic> _seller;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _businessAddress = TextEditingController();
  final TextEditingController _businessPhone = TextEditingController();
  final TextEditingController _businessDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSeller();
  }

  void fetchSeller() async {
    try {
      final sellerData = await ApiServices.getSellerById(widget.userId);

      if (sellerData['status'] == 'error') {
        print('Error fetching seller data: ${sellerData['message']}');
        // Show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(sellerData['message']),
          ),
        );
      } else {
        setState(() {
          _seller = sellerData;
          _businessName.text = _seller['businessName'];
          _businessAddress.text = _seller['businessAddress'];
          _businessPhone.text = _seller['businessPhoneNo'];
          _businessDescription.text = _seller['businessDescription'];
        });
      }
    } catch (e) {
      print('Error fetching seller data: $e');
      showToast(message: 'An error occurred while fetching seller data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Seller Profile',
            style: TextStyle(
                color: Color(0xFFFF5C01),
                fontSize: 28,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1, // left
              0, // top
              MediaQuery.of(context).size.width * 0.1, // right
              0, // bottom
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
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
                          'businessDescription': _businessDescription.text,
                          // 'userId': widget.userId,
                        };

                        try {
                          final response = await ApiServices.updateSeller(
                              widget.userId, data);

                          if (response['status'] != 'error') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(), //SellerProfile(userId: widget.userId),
                              ),
                            );
                          } else {
                            showToast(message: response['message']);
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          showToast(message: 'An unexpected error occurred');
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    text: 'submit',
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
