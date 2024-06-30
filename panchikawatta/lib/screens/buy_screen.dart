// ignore_for_file: unnecessary_null_comparison, unused_import

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/wishlist.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:panchikawatta/services/get_api_services.dart';

class BuyScreen extends StatefulWidget {
  final int sparePartId;

  const BuyScreen({super.key, required this.sparePartId});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late Future<SparePart> futureSparePart;

  @override
  void initState() {
    super.initState();
    futureSparePart = GetApiService().getSparePartById(widget.sparePartId);
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
          "Buy",
          style: TextStyle(
              color: Color(0xffFF5C01),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            },
            child: const Icon(
              Icons.favorite_outline,
              size: 25,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile_image.png'),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: FutureBuilder<SparePart>(
        future: futureSparePart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Spare part not found'));
          } else {
            var sparePart = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Swiper(
                            autoplay: true,
                            autoplayDelay: 5000,
                            itemBuilder: (BuildContext context, int index) {
                              final imageUrl = sparePart.imageUrl;
                              if (imageUrl == null || imageUrl.isEmpty) {
                                return Image.asset(
                                  'assets/images/no_image.png',
                                  fit: BoxFit.contain,
                                );
                              } else {
                                return Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/no_image.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                );
                              }
                            },
                            itemCount:
                                1, // You can set this to the number of images you have
                            pagination: const SwiperPagination(
                              alignment: Alignment.bottomCenter,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      sparePart.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Rs. ${sparePart.price}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Year: ${sparePart.year}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Make: ${sparePart.make}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () {
                        // Add your buy logic here
                      },
                      text: 'Buy Now',
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
