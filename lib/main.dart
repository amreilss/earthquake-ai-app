import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Pages
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/main_navigation_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [Background] Message: ${message.notification?.title}');

  // ✅ เก็บไว้ใน SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('alertHistory') ?? [];
  history.insert(0, jsonEncode(message.data));
  await prefs.setStringList('alertHistory', history);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ ใช้สำหรับ background message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Android Notification Channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ต้องตรงกับที่ใช้ใน local notification
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.high,
  );

  // ✅ Register Notification Channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Initialize flutter_local_notifications
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  // ✅ เมื่อแอปเปิดอยู่ (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // ✅ แสดง Notification
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );

      // ✅ เก็บไว้ใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList('alertHistory') ?? [];
      history.insert(0, jsonEncode(message.data));
      await prefs.setStringList('alertHistory', history);
    }
  });

  // ✅ เมื่อผู้ใช้คลิก Notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 Notification clicked: ${message.notification?.title}');
    // คุณสามารถใช้ Navigator.pushNamed() ไปหน้า /alert ได้ที่นี่
  });

  // ✅ แสดง FCM Token สำหรับทดสอบ
  String? token = await FirebaseMessaging.instance.getToken();
  print('📱 FCM Token: $token');

  runApp(const EarthquakeAIApp());
}

class EarthquakeAIApp extends StatelessWidget {
  const EarthquakeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'InriaSerif'),
      initialRoute: '/login',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/forgot': (context) => ForgotPasswordPage(),
        '/alert': (context) => const MainNavigationPage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
      },
    );
  }
}
