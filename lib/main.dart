import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Pages
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/main_navigation_page.dart';
import 'pages/privacy_policy_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Initialize Firebase
  await Firebase.initializeApp();

  // ✅ 2. สร้าง Notification Channel สำหรับ Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ต้องตรงกับ AndroidManifest.xml
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.high,
  );

  // ✅ 3. ลงทะเบียน Channel กับระบบ
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ 4. Init flutter_local_notifications
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  // ✅ 5. รับ notification ขณะแอปเปิด
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
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
    }
  });

  // ✅ 6. สำหรับกรณีคลิกที่ notification (เปิดแอปจากปิด)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 Notification clicked: ${message.notification?.title}');
    // Navigator.pushNamed(context, '/alert'); // <- ใส่ logic นำทางเพิ่มได้
  });

  // ✅ 7. กำหนด handler สำหรับ background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ 8. แสดง Token ไว้ใช้ทดสอบ (เอาไปยิงใน Firebase Console หรือ Postman ได้)
  String? token = await FirebaseMessaging.instance.getToken();
  print('📱 FCM Token: $token');

  runApp(const EarthquakeAIApp());
}

// ✅ 9. Handler สำหรับ notification ขณะแอปถูก kill หรืออยู่ background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 [Background] Message: ${message.notification?.title}');
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
