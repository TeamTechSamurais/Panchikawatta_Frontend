import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panchikawatta/screens/profile_page.dart';
import 'firebase_options.dart';
import 'package:panchikawatta/screens/add_vehicle_details.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initializeFirebase();
  runApp( MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  ProfilePage() ,
    );
  }
}

// Initialize Firebase
_initializeFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
} 
