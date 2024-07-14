import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ServicesAds extends StatefulWidget {
  @override
  _ServicesAdsState createState() => _ServicesAdsState();
}

class _ServicesAdsState extends State<ServicesAds> {
  Future<List<Service>>? _servicesFuture;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? sellerEmail = prefs.getString('userEmail');

    if (sellerEmail != null) {
      setState(() {
        _servicesFuture = _getServices(sellerEmail);
      });
    }
  }

  Future<List<Service>> _getServices(String sellerEmail) async {
    final response = await http.get(
      Uri.parse(
          '${Utils.baseUrl}/adListing/getServices?sellerEmail=$sellerEmail'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<void> _deleteAd(int adId) async {
    final response = await http.delete(
      Uri.parse('${Utils.baseUrl}/adListing/deleteAd/$adId'),
    );

    if (response.statusCode == 200) {
      // Refresh the services list
      setState(() {
        _servicesFuture = _getServices('');
      });
    } else {
      throw Exception('Failed to delete ad');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Service>>(
              future: _servicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF5C01)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No services found'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final service = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: service.imageUrls.isNotEmpty
                              ? Image.network(
                                  service.imageUrls[0],
                                  width: 70,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                          title: Text(
                            service.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'Price: ${service.price}',
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Posted on: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', // Adjust date if available
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 127, 126, 126),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteAd(service.id);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
