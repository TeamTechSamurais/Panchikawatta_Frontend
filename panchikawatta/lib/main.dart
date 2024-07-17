// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panchikawatta/screens/app.dart';
import 'package:panchikawatta/services/firebase_api.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'screens/storage_helper.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
// }
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseApi firebaseApi = FirebaseApi();
    await firebaseApi.initNotifications();
  } else {
    print('User is not logged in');
  }

  String? jwtToken = await getJwtToken();

  if (jwtToken != null) {
    bool isExpired = _isJwtExpired(jwtToken);
    if (isExpired) {
      runApp(MyApp(initialRoute: '/login', navigatorKey: navigatorKey));
    } else {
      runApp(MyApp(initialRoute: '/home', navigatorKey: navigatorKey));
    }
  } else {
    runApp(MyApp(initialRoute: '/login', navigatorKey: navigatorKey));
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
