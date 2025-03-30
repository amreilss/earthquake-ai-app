import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
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