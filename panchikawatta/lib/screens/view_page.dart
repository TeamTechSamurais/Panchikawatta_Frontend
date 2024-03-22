import 'package:flutter/material.dart';
//test2
class ViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          // Row to align back button, monitor icon, and text horizontally
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigate back when back button is pressed
              },  //comit 2
              icon: Icon(Icons.arrow_back),
            ),
            Icon(Icons.monitor, color: Color(0xFFFF5C01)),
            SizedBox(width: 8),
            Text(
              'View',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildListItem('Accounts'),
                _buildListItem('Sellers'),
                _buildListItem('Buyers'),
                _buildListItem('Ads'),
                _buildListItem('Reviews'),
                _buildListItem('Sales'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Color(0xFFEBEBEB),
        ),
        child: ListTile(
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Handle button tap
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ViewPage(),
  ));
}
