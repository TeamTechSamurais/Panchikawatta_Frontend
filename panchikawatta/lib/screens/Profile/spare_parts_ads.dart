import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:panchikawatta/global/globals.dart' as globals;

class SparePartsAds extends StatefulWidget {
  @override
  _SparePartsAdsState createState() => _SparePartsAdsState();
}

class _SparePartsAdsState extends State<SparePartsAds> {
  Future<List<SparePart>>? _sparePartsFuture;
  String? sellerEmail;

  @override
  void initState() {
    super.initState();
    _fetchSellerEmail();
  }

  Future<void> _fetchSellerEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    sellerEmail = prefs.getString('userEmail');
    if (sellerEmail != null) {
      setState(() {
        _sparePartsFuture = getSpareParts();
      });
    }
  }

  Future<List<SparePart>> getSpareParts() async {
    int? sellerId = globals.userId;
    final response = await http.get(
        Uri.parse('${Utils.baseUrl}/users/getSparePartsBySeller/$sellerId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SparePart.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spare parts');
    }
  }

  Future<void> _deleteAd(int id) async {
    final response = await http.delete(
      Uri.parse('${Utils.baseUrl}/adPosting/deleteSparePart/$id'),
    );

    if (response.statusCode == 200) {
      // Refresh the spare parts list
      setState(() {
        _sparePartsFuture = getSpareParts();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad deleted successfully')),
      );
    } else {
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete ad')),
      );
      throw Exception('Failed to delete ad');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<SparePart>>(
              future: _sparePartsFuture,
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
                    child: Text('No ads found'),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final sparePart = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 3,
                        child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: sparePart.imageUrls.isNotEmpty
                                ? Image.network(
                                    sparePart.imageUrls[0],
                                    width: 70,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported,
                                    size: 50),
                            title: Text(
                              sparePart.title,
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
                                  'Price: ${sparePart.price}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Posted on: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', // Adjust date if available
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color:
                                          Color.fromARGB(255, 127, 126, 126)),
                                ),
                              ],
                            )),
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
