import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.notification?.title}");
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // _firebaseMessaging.getToken().then((value) => print(value));
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/hanaang');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    // await flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (details) {},
    //   onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    // );

    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    shoNotification(
      title: "${message.notification?.title}",
      body: message.notification?.body,
    );
  }

  notificationDetail() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          "com.example.admin_hanaang",
          "admin_hanaang",
          importance: Importance.max,
          priority: Priority.high,
          ticker: "ticker",
          enableLights: true,
          enableVibration: true,
          channelShowBadge: true,
          playSound: true,
          icon: "hanaang",
          color: Colors.yellow,
        ),
        iOS: DarwinNotificationDetails());
  }

  Future shoNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetail(),
    );
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }
}
