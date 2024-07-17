import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:panchikawatta/main.dart';
import 'package:panchikawatta/screens/chat_room.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    final chatRoomId = message.data['chatRoomId'];
    final senderId = message.data['senderId'];
    final senderDisplayPicture = _firestore.collection('users').doc(senderId).get().then((value) => value.data()!['profile_picture']);

    final Map<String, dynamic> userMap = {
      'uid': senderId,
      'name': message.data['senderName'],
      'profile_picture': senderDisplayPicture,
    };
    // navigatorKey.currentState!.pushNamed(
    //   ChatRoom(userMap: userMap, chatRoomId: chatRoomId).route,
    //   arguments: message,
    // );
    navigatorKey.currentState!.pushNamed(ChatRoom.route, arguments: {
      'userMap': userMap,
      'chatRoomId': chatRoomId,
    });
  }

  Future initLocalNotifications() async {
    final android = AndroidInitializationSettings('@drawable/ic_notification');
    final initializationSettings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
          final payload = response.payload;
          if (payload == null) return;
          final message = RemoteMessage.fromMap(jsonDecode(payload));
          handleMessage(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage); 
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      final senderName = message.data['senderName'];
      final messageText = message.data['messageText'];
      final chatRoomId = message.data['chatRoomId'];
      _localNotifications.show(
        notification.hashCode,
        senderName,
        messageText,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_notification',
            // importance: _androidChannel.importance,
          ),
        ),
        payload: chatRoomId, //jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    saveTokenToDatabase(fcmToken);
    print('FCM Token: $fcmToken');
    initPushNotifications();
    initLocalNotifications();
  }

  void saveTokenToDatabase(String? token) async {
    if (token != null) {
      await _firestore.collection('users').doc(currentUserId).update({
        'fcmToken': token,
      });
    }
  }
}