// ignore_for_file: unnecessary_null_comparison, unused_import

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/screens/User/wishlist.dart';
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
  final double _padding = 20.0; // Define common padding value

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
          "Details",
          style: TextStyle(
              color: Color(0xFFFF5C01),
              fontSize: 28,
              fontWeight: FontWeight.w500),
        ),
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
              size: 30,
              color: Color(0xFFFF5C01),
            ),
          ),
          const SizedBox(width: 30)
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
              padding: EdgeInsets.symmetric(
                  horizontal: _padding), // Apply common padding
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: 350,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/corolla_headlight.jpeg',
                        fit: BoxFit.contain,
                      ),
                      // child: Swiper(
                      //   // autoplay: true,
                      //   // autoplayDelay: 5000,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     final imageUrl = sparePart.imageUrl;
                      //     if (imageUrl == null || imageUrl.isEmpty) {
                      //       return Image.asset(
                      //         'assets/images/no_image.png',
                      //         fit: BoxFit.contain,
                      //       );
                      //     } else {
                      //       return Image.network(
                      //         imageUrl,
                      //         fit: BoxFit.contain,
                      //         errorBuilder: (context, error, stackTrace) {
                      //           return Image.asset(
                      //             'assets/images/no_image.png',
                      //             fit: BoxFit.contain,
                      //           );
                      //         },
                      //       );
                      //     }
                      //   },
                      //   itemCount:
                      //       1, // You can set this to the number of images you have
                      //   pagination: const SwiperPagination(
                      //     alignment: Alignment.bottomCenter,
                      //   ),
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: CustomButton(
                      onPressed: () {
                        // Add your buy logic here
                      },
                      text: '              Buy it Now              ',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        sparePart.title,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Rs. ${sparePart.price}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 100),
                      GestureDetector(
                        onTap: () {
                          // Add code to call the phone number here
                        },
                        child: const Icon(
                          Icons.local_phone_rounded,
                          color: Color(0xFFFF5C01),
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          // Add code to call the phone number here
                        },
                        child: const Icon(
                          Icons.mail_rounded,
                          color: Color(0xFFFF5C01),
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' ${sparePart.make} ',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Text(
                                  ' ${sparePart.model}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  ' ${sparePart.year}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    sparePart.condition,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    sparePart.fuel,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255), // Background color
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    sparePart.origin,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFF5C01)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              sparePart.description,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
