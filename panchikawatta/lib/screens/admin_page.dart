import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}
//comment test
class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle back button action here
              },
              icon: Icon(Icons.arrow_back),
            ),
            const Text('My profile'),
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Changed to spaceEvenly
        children: [
          ElevatedButton(
            onPressed: () {
              // Handle view analytics action here
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFFFF5C01),
            ),
            child: const Text('View Analytics'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle manage account action here
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFFFF5C01),
            ),
            child: const Text('Manage Account'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle sellers action here
                  },
                  child: const Text('Sellers'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle ads action here
                  },
                  child: const Text('Ads'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle buyers action here
                  },
                  child: const Text('Buyers'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFE3E3E3),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Handle search action here
              },
              icon: Icon(Icons.search, color: Color(0xFFFF5C01)),
            ),
            IconButton(
              onPressed: () {
                // Handle profile action here
              },
              icon: Icon(Icons.person, color: Color(0xFFFF5C01)),
            ),
            IconButton(
              onPressed: () {
                // Handle notification action here
              },
              icon: Icon(Icons.notifications, color: Color(0xFFFF5C01)),
            ),
          ],
        ),
      ),
    );
  }
}