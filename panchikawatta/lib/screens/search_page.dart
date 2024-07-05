import 'package:flutter/material.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:panchikawatta/screens/User/filter_sort.dart';
import 'package:panchikawatta/screens/User/services_list.dart';
import 'package:panchikawatta/screens/User/spareparts_list.dart';
import 'package:panchikawatta/services/get_api_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required List<SparePart> ads});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<SparePart>> _spareParts;
  late Future<List<Service>> _services;
  late Future<List<SparePart>> _searchedSpareParts;
  late Future<List<Service>> _searchedServices;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _spareParts = GetApiService().getSpareParts();
    _services = GetApiService().getServices();
  }

  void _search() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _searchedSpareParts =
            GetApiService().searchSpareparts(_searchController.text);
        _searchedServices =
            GetApiService().searchServices(_searchController.text);
      } else {
        _spareParts = GetApiService().getSpareParts();
        _services = GetApiService().getServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        actions: const [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 8),
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
              SizedBox(width: 5),
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const TabBar(
                    indicatorColor: Color(0xffFF5C01),
                    labelColor: Color(0xffFF5C01),
                    unselectedLabelColor: Colors.black,
                    labelStyle: TextStyle(fontSize: 15),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: 'Spareparts'),
                      Tab(text: 'Services'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFFF5C01),
                        size: 25,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFAFAFA),
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      hintText: "Search",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xffFAFAFA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Color(0xffFAFAFA)),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      _search();
                    },
                  ),
                  const SizedBox(height: 10),
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
                            SizedBox(width: 5),
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
                              builder: (context) => const FilterSortScreen(),
                            ),
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
                            SizedBox(width: 5),
                            Icon(
                              Icons.grid_view_outlined,
                              color: Color(0xffFF5C01),
                              size: 23,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SparePartsList(
                    spareParts:
                        _isSearching ? _searchedSpareParts : _spareParts,
                  ),
                  ServicesList(
                    services: _isSearching ? _searchedServices : _services,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
