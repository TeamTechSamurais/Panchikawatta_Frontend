import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26
          ),
          onPressed: () {
            // Navigate to the previous page
            Navigator.pop(context);
          },
        ),
        title: const Text('Chats', style: TextStyle(color: Color(0xFFFF5C01), fontSize: 28)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {
              // Navigate to the search page
            },
          ),
        ],
      ),
    );
  }
}