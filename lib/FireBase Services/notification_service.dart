import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:ecommerce_customer/PAGES/orderHistoryPage.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

// we have to handle it for 3 states 1 -> active 2-> inactive 3-> terminated

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androiInitializationSettings = const AndroidInitializationSettings(
      '@drawable/ic_launcher',
    );

    var initializationSetting = InitializationSettings(
      android: androiInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSetting,
      onDidReceiveBackgroundNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    // context.go('/orders');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => YourOrders()),
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage(); // first message got in killed state
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //in the background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      initLocalNotifications(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      // Random.secure().nextInt(100000).toString(),
      'high_importance_channel',
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'My Channel Description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_launcher',
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        id: 0,
        title: message.notification?.title,
        body: message.notification?.body,
        notificationDetails: notificationDetails,
      );
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permission Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Provisional Permission Granted');
    } else {
      AppSettings.openAppSettings();
      print('User Denied notif Permission');
    }
  }

  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  void isTokenRefresh() async {
    // checks if token is refreshed
    messaging.onTokenRefresh.listen((event) async{
      print("New fcm token issued now trying to setFcm ");
      try {
          var body = {"fcm": event.toString()};
          final res = await Dioclient.dio.post("/setFcm", data: body);
          if (res.statusCode == 200) {
            print("FCM SET SUCCESSFULL ✅");
          } else {
            print("ERROR IN SETTING FCM ❌");
          }
        } catch (err) {
          print("❌ Got in catch while setting FCM Error = ${err}");
        }
      event.toString();
    });
  }
}
