import 'package:flutter/material.dart';

class SafetyPage extends StatelessWidget {
  const SafetyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(title: const Text('Safety')),
      body: const Center(child: Text('Safety Tips Placeholder')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushReplacementNamed(context, '/alert');
          if (index == 2) Navigator.pushReplacementNamed(context, '/setting');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Safety'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alert'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}