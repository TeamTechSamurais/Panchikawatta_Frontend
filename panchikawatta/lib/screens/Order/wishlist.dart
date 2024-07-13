import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panchikawatta/constant/utils.dart';

class WishlistScreen extends StatefulWidget {
  final int userId;

  const WishlistScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<SparePart>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = fetchFavorites(widget.userId);
  }

Future<List<SparePart>> fetchFavorites(int userId) async {
  var url = Uri.parse('${Utils.baseUrl}/adListing/favorites/$userId');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    print(response.body); // Log the body to debug
    List<dynamic> body = jsonDecode(response.body);
    List<SparePart> spareParts = body.map((dynamic item) => SparePart.fromJson(item['sparePart'])).toList();
    return spareParts;
  } else {
    throw Exception('Failed to load favorites');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Wishlist"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/user/profile.jpg'), // Replace with actual URL
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SparePart>>(
              future: _favorites,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text('No favorites added'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var sparePart = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(sparePart.imageUrl), // Replace with actual image URL field
                        title: Text(sparePart.title),
                        subtitle: Text('Rs. ${sparePart.price}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SparePart {
  final int id;
  final String title;
  final String imageUrl;
  final double price;

  SparePart({required this.id, required this.title, required this.imageUrl, required this.price});

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'] ?? 0,
      title: json['title'],
      imageUrl: json['imageUrls'][0], // Assuming the first image is the main one
      price: json['price'].toDouble(),
    );
  }
}
