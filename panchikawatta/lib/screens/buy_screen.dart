import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:panchikawatta/components/custom_button.dart';
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/screens/wishlist.dart';
import 'package:panchikawatta/models/sparepart.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  late Future<SparePart> futureSparePart;

  @override
  void initState() {
    super.initState();
    futureSparePart = fetchSparePart();
  }

  Future<SparePart> fetchSparePart() async {
    final response =
        await http.get(Uri.parse('${Utils.baseUrl}/spare-parts/:id'));

    if (response.statusCode == 200) {
      return SparePart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load spare part');
    }
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
          ),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xffFF5C01),
          ),
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
              Icons.favorite_border_sharp,
              size: 35,
              color: Color(0xffFF5C01),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: FutureBuilder<SparePart>(
        future: futureSparePart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildSparePartDetails(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildSparePartDetails(SparePart sparePart) {
    return Column(
      children: [
        SizedBox(
          height: 290,
          width: double.infinity,
          child: Swiper(
            itemWidth: 300.0,
            itemHeight: 200.0,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    sparePart.imageUrl,
                    height: 250,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${index + 1}/3',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: 3,
            control: const SwiperControl(color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Add to Wishlist',
                    onPressed: () {
                      // Add to wishlist action
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    sparePart.make,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 1,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${sparePart.year}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Rs${sparePart.price}.00',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.phone_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Call action
                        },
                      ),
                      const SizedBox(width: 3),
                      IconButton(
                        icon: const Icon(
                          Icons.message_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Message action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.6,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      const Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 25,
                            color: Color(0xFFFF5C01),
                          ),
                          Text(
                            'Western, ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Colombo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.018),
                      Row(
                        children: [
                          buildTag(sparePart.condition),
                          const SizedBox(width: 7),
                          buildTag(sparePart.fuel),
                          const SizedBox(width: 7),
                          buildTag(sparePart.origin),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFF5C01),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      Text(
                        sparePart.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTag(String text) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
