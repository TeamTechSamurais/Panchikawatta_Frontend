import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/screens/Order/info.dart';

class BuyNowScreen extends StatefulWidget {
  @override
  _BuyNowScreenState createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String _deliveryMethod = 'COD';

  Future<void> placeOrder(BuildContext context) async {
    String email = emailController.text;
    String phone = phoneController.text;

    // Email validation
    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (!emailValid) {
      _showErrorDialog(context, 'Invalid email format');
      return;
    }

    // Phone number validation
    bool phoneValid = RegExp(r"^\d{10}$").hasMatch(phone);
    if (!phoneValid) {
      _showErrorDialog(context, 'Phone number must be exactly 10 digits');
      return;
    }

    final response = await http.post(
      Uri.parse('${Utils.baseUrl}/adListing/placeOrder'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': fullNameController.text,
        'email': email,
        'phoneNO': phone,
        'address': addressController.text,
        'deliveryMethod': _deliveryMethod,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InfoScreen(orderId: json.decode(response.body)['orderId'])),
      );
    } else {
      _showErrorDialog(context, 'Failed to place order');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Now', style: TextStyle(color: Color(0xFFFF5C01))),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name with Initial',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telephone',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address To Deliver',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text('Delivery Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text('Cash on Delivery'),
                    leading: Radio<String>(
                      value: 'COD',
                      groupValue: _deliveryMethod,
                      onChanged: (String? value) {
                        setState(() {
                          _deliveryMethod = value!;
                        });
                      },
                      activeColor: Color(0xFFFF5C01),
                    ),
                  ),
                  ListTile(
                    title: Text('Buy Online'),
                    leading: Radio<String>(
                      value: 'Online',
                      groupValue: _deliveryMethod,
                      onChanged: null, // Disabled for now
                      activeColor: Color(0xFFFF5C01),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5C01),
                minimumSize: Size(double.infinity, 50), // Make the button take the full width
              ),
              onPressed: () => placeOrder(context),
              child: Text('Place Order', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
