import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panchikawatta/screens/app.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'screens/storage_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  String? jwtToken = await getJwtToken();

  if (jwtToken != null) {
    bool isExpired = _isJwtExpired(jwtToken);
    if (isExpired) {
      runApp(const MyApp(initialRoute: '/login'));
    } else {
      runApp(const MyApp(initialRoute: '/home'));
    }
  } else {
    runApp(const MyApp(initialRoute: '/login'));
  }
}

bool _isJwtExpired(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return true;
  }

  final payload =
      json.decode(utf8.decode(base64.decode(base64.normalize(parts[1]))));
  final exp = payload['exp'];
  final now = DateTime.now().millisecondsSinceEpoch / 1000;

  return now > exp;
}
