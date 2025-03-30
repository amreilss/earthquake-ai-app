import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';
import 'pages/splash_page.dart';
import 'pages/home_alert_page.dart';
import 'pages/safety_page.dart';
import 'pages/setting_page.dart';
import 'pages/privacy_policy_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EarthquakeAIApp());
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
        '/alert': (context) => const HomeAlertPage(),
        '/safety': (context) => const SafetyPage(),
        '/setting': (context) => const SettingPage(),
        '/privacy': (context) => const PrivacyPolicyPage(),
      },
    );
  }
}
