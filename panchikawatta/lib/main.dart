// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:panchikawatta/screens/profile_page.dart';
// import 'firebase_options.dart';
// import 'package:panchikawatta/screens/SplashScreen.dart';
// import 'screens/search_page1.dart';
// import 'screens/notification_page.dart';
// import 'screens/alert_page.dart';
// import 'package:panchikawatta/screens/login.dart';

// import 'package:panchikawatta/global/common/toast.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _initializeFirebase();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   User? user;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     print(user?.uid.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: user != null ? const MyHomePage() : const SplashScreen(),
//       routes: {
//         'SplashScreen': (context) => const SplashScreen(),
//         'login': (context) => login(),
//         // Define the login route here
//       },
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const search_page1(),
//     const notification_page(),
//     const alert_page(),
//     ProfilePage(),
//   ];

//   final List<Widget> _guestPages = [
//     const search_page1(),
//   ];

//   void _onItemTapped(int index) {
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user == null && index != 0) {
//       // Show a message or do nothing if the user is not logged in and tries to access other pages
//       showToast(message: "Please log in to access this page.");
//       return;
//     }

//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     List<Widget> pages = user != null ? _pages : _guestPages;
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Notifications',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.lightbulb),
//             label: 'Quick Help',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: const Color(0xFFFF5C01),
//         unselectedItemColor: const Color.fromARGB(255, 117, 117, 117),
//       ),
//     );
//   }
// }

// // Initialize Firebase
// Future<void> _initializeFirebase() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/profile_page.dart';
import 'package:panchikawatta/screens/SplashScreen.dart';
import 'screens/search_page1.dart';
import 'screens/notification_page.dart';
import 'screens/alert_page.dart';
import 'screens/login.dart';
import 'package:panchikawatta/global/common/toast.dart';
import 'dart:convert';
import 'package:panchikawatta/screens/storage_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  String? jwtToken = await getJwtToken();

  if (jwtToken != null) {
    bool isExpired = _isJwtExpired(jwtToken);
    if (isExpired) {
      runApp(MyApp(initialRoute: '/login'));
    } else {
      runApp(MyApp(initialRoute: '/home'));
    }
  } else {
    runApp(MyApp(initialRoute: '/login'));
  }
}

bool _isJwtExpired(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return true;
  }

  final payload = json.decode(utf8.decode(base64.decode(base64.normalize(parts[1]))));
  final exp = payload['exp'];
  final now = DateTime.now().millisecondsSinceEpoch / 1000;

  return now > exp;
}

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
        '/login': (context) =>const SplashScreen(),
        '/home': (context) => MyHomePage(),
        '/SplashScreen':(context) =>SplashScreen(),
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
    const search_page1(ads: [],),
    const notification_page(),
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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<Widget> pages = user != null ? _pages : _guestPages;
    return Scaffold(
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
    );
  }
}
 
