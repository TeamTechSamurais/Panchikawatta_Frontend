import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/User/buy_screen.dart';
import 'package:panchikawatta/services/get_api_services.dart';
import 'package:panchikawatta/models/sparepart.dart';

class WishlistScreen extends StatefulWidget {
  final int userId;

  const WishlistScreen({super.key, required this.userId});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<SparePart>> futureFavorites;

  @override
  void initState() {
    super.initState();
    futureFavorites = GetApiService().getUserFavorites(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Wishlist",
          style: TextStyle(
              color: Color(0xFFFF5C01),
              fontSize: 28,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<List<SparePart>>(
        future: futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite spare parts found'));
          } else {
            var favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                var sparePart = favorites[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(sparePart.imageUrl),
                    title: Text(sparePart.title),
                    subtitle: Text('Rs. ${sparePart.price}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuyScreen(
                            sparePartId: sparePart.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
