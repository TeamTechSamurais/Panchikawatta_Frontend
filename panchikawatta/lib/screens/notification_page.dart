import 'package:flutter/material.dart';
import 'package:panchikawatta/screens/Notification/chat.dart';
import 'package:panchikawatta/screens/Notification/reminder.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Color(0xffFF5C01),
            labelColor: Color(0xffFF5C01),
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [Tab(text: 'Chats'), Tab(text: 'Reminders')],
          ),
        ),
        body: const TabBarView(
          children: [
            ChatsPage(),
            ReminderPage(),
          ],
        ),
      ),
    );
  }
}
