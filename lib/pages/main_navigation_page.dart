import 'package:flutter/material.dart';
import 'home_alert_page.dart';
import 'safety_page.dart';
import 'setting_page.dart';
import '../widgets/custom_navbar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 1;

  // ✅ เก็บ state แต่ละหน้าไว้ใน IndexedStack ไม่ให้ rebuild
  final List<Widget> _pages = const [
    SafetyPage(),
    HomeAlertPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
