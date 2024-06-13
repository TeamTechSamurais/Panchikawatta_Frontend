import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text(
              'Anne_fernando82',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Spacer(),
            Text(
              'Buyer',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            // CircleAvatar(
            //   backgroundImage: AssetImage(
            //       'assets/profile.jpg'), // Update with your profile image path
            // ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5C01)),
                hintText: 'Search',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Location button press
                  },
                  icon: const Icon(Icons.location_on, color: Colors.orange),
                  label: const Text(
                    'Location',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Filter & Sort button press
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.orange),
                  label: const Text(
                    'Filter & Sort',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
                children: [
                  _buildGridItem(
                    'Toyota CHR',
                    'Rs. 850,000.00',
                    '2014',
                    'Hybrid',
                    'assets/engine.jpg', // Update with your image path
                  ),
                  _buildGridItem(
                    'Toyota CHR',
                    'Rs. 850,000.00',
                    null,
                    null,
                    'assets/engine.jpg', // Update with your image path
                  ),
                  _buildGridItem(
                    'Toyota CHR',
                    'Rs. 850,000.00',
                    '2014',
                    'Hybrid',
                    'assets/engine.jpg', // Update with your image path
                  ),
                  _buildGridItem(
                    'Toyota CHR',
                    'Rs. 850,000.00',
                    null,
                    null,
                    'assets/engine.jpg', // Update with your image path
                  ),
                  _buildGridItem(
                    'Toyota CHR',
                    'Rs. 850,000.00',
                    '2014',
                    'Hybrid',
                    'assets/engine.jpg', // Update with your image path
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF5C01),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    String title,
    String price,
    String? year,
    String? fuelType,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (year != null) ...[
              const SizedBox(height: 8),
              Text(
                year,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
            if (fuelType != null) ...[
              const SizedBox(height: 8),
              Text(
                fuelType,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
