// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panchikawatta/global/common/toast.dart';
import 'package:panchikawatta/screens/SplashScreen.dart';
import 'package:panchikawatta/screens/alert_page.dart';
import 'package:panchikawatta/screens/notification_page.dart';
import 'package:panchikawatta/screens/profile_page.dart';
import 'package:panchikawatta/screens/search_page1.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const SplashScreen(),
        '/home': (context) => MyHomePage(),
        '/SplashScreen': (context) => SplashScreen(),
        // Define other routes here
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const search_page1(ads: []),
    const NotificationPage(),
    const alert_page(),
    ProfilePage(),
  ];

  final List<Widget> _guestPages = [
    const search_page1(ads: []),
  ];

  void _onItemTapped(int index) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null && index != 0) {
      // Show a message or do nothing if the user is not logged in and tries to access other pages
      showToast(message: "Please log in to access this page.");
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> pages = user != null ? _pages : _guestPages;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: 'Quick Help',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFFFF5C01),
          unselectedItemColor: const Color.fromARGB(255, 117, 117, 117),
        ),
      ),
    );
  }
}
