// ignore_for_file: avoid_print, camel_case_types

import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/buy_screen.dart';
import 'package:panchikawatta/screens/filter_sort.dart';
import 'package:panchikawatta/services/api_services.dart';
import 'package:panchikawatta/models/sparepart.dart';

class search_page extends StatefulWidget {
  const search_page({super.key});

  @override
  State<search_page> createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {
  late Future<List<SparePart>> _sparepart;

  @override
  void initState() {
    super.initState();
    _sparepart = ApiService().getSpareParts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_rounded,
          size: 30,
        ),
        elevation: 0,
        actions: const [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Buyer',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffFF5C01)),
                  ),
                  Text(
                    'Anne_fernando82',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: FutureBuilder<List<SparePart>>(
        future: _sparepart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log the error for debugging
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No SpareParts found'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xffFF5C01),
                            size: 30,
                          ),
                          filled: true,
                          fillColor: const Color(0xffFAFAFA),
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          hintText: "Search",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Color(0xffFAFAFA))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Color(0xffFAFAFA)))),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'newest',
                              child: Text('Newest first'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'best_match',
                              child: Text('Best match'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'price_low_high',
                              child: Text('Price: Low to High'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'price_high_low',
                              child: Text('Price: High to Low'),
                            ),
                          ],
                          onSelected: (String value) {
                            // Handle sorting logic here
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.sort_rounded,
                                color: Color(0xffFF5C01),
                                size: 25,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Sort by',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffFF5C01),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterSortScreen()),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Filter results',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffFF5C01),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.grid_view_outlined,
                                color: Color(0xffFF5C01),
                                size: 23,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: GridView.builder(
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, i) {
                            var sparePart = snapshot.data![i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BuyScreen()));
                              },
                              child: Container(
                                width: 82,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xffEBEBEB)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      sparePart.imageUrl,
                                      height: 73,
                                      width: 81,
                                      // errorBuilder:
                                      //     (context, error, stackTrace) {
                                      //   return Image.asset(
                                      //       'assets/images/no_image.png',
                                      //       height: 73,
                                      //       width: 81);
                                      // },
                                    ),
                                    Text(
                                      sparePart.title,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Rs. ${sparePart.price}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      '${sparePart.year}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      sparePart.make,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
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
