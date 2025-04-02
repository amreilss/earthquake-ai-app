import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Pages
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/main_navigation_page.dart';
import 'pages/privacy_policy_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Initialize Firebase
  await Firebase.initializeApp();

  // ✅ 2. Background FCM handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const EarthquakeAIApp());
}

// ✅ 3. ฟังก์ชันสำหรับ handle push notification ขณะ background/terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [Background] Received message: ${message.notification?.title}');
}

class EarthquakeAIApp extends StatelessWidget {
  const EarthquakeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake AI',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/alert': (context) => const MainNavigationPage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
      },
    );
  }
}
