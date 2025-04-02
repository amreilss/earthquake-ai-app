import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_alert_page.dart' as alert;
import 'pages/safety_page.dart';
import 'pages/setting_page.dart';
import 'pages/privacy_policy_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashPage(),
  '/login': (context) => const LoginPage(),
  '/signup': (context) => const SignUpPage(),
  '/alert': (context) => const alert.HomeAlertPage(),
  '/safety': (context) => const SafetyPage(),
  '/setting': (context) => const SettingPage(),
  '/privacy': (context) => const PrivacyPolicyPage(),
};

