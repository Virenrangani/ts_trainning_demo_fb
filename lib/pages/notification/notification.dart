import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../bottom_navbar/bottom_nav_bar.dart';

class RequestNotification {
  final FirebaseMessaging firebaseMessaging =
      FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await firebaseMessaging.getToken();
    print("FCM Token: $fcmToken");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Title: ${message.notification?.title}");
      print("Foreground Body: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked!");
      _handleNavigation(message);
    });

    RemoteMessage? initialMessage =
    await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNavigation(initialMessage);
    }
  }

  void _handleNavigation(RemoteMessage message) {
    final screen = message.data["screen"];

    print("Screen value from FCM : ${message.data["screen"]}");
    int index = 0;

    if (screen == "dashboard") {
      index = 0;
    } else if (screen == "map") {
      index = 1;
    }else{
      index=0;
    }

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BottomNav(initialIndex: index),
      ),
          (route) => false,
    );
  }
}