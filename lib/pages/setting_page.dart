import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(title: const Text('Setting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'First Name')),
            TextField(decoration: InputDecoration(labelText: 'Last Name')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/safety');
          if (index == 1) Navigator.pushReplacementNamed(context, '/alert');
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