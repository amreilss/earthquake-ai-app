import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Pages
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/main_navigation_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart'; // ✅ เพิ่มมาเพื่อใช้กับ routes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  // ✅ FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const EarthquakeAIApp());
}

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
      theme: ThemeData(fontFamily: 'InriaSerif'),
      initialRoute: '/login',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => LoginPage(), // ✅ อย่าใช้ const
        '/signup': (context) => SignUpPage(),
        '/forgot': (context) => ForgotPasswordPage(),
        '/alert': (context) => const MainNavigationPage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
      },
    );
  }
}