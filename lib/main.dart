import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart'; // ✅ import หน้าแรก
import 'routes.dart'; // ✅ routes ควรแยกไว้ที่ routes.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Firebase init
  runApp(const EarthquakeAIApp());
}

class EarthquakeAIApp extends StatelessWidget {
  const EarthquakeAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake AI',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
