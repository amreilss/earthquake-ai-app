// 🚨 lib/pages/home_alert_page.dart (ออกแบบตาม UI ที่แนบ)
import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';

class HomeAlertPage extends StatelessWidget {
  const HomeAlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.13),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.04,
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alert',
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/logo.png', // แก้ path จาก asset → assets
                width: screenHeight * 0.12,
                height: screenHeight * 0.11,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Your area',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'InriaSerif'),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'KMITL, 1 Chalong Krung 1 Alley, Lat Krabang,\nBangkok 10520, Thailand',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/komhua.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Notification',
                  style: TextStyle(
                    fontFamily: 'InriaSerif',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date : 12/02/2025'),
                    SizedBox(height: 4),
                    Text('Area : KMITL, 1 Chalong Krung 1 Alley, Lat Krabang, Bangkok 10520, Thailand'),
                    SizedBox(height: 8),
                    Text('Magnitude : kuay'),
                    Text('Dept : kuay'),
                    Text('Reaction : kuay'),
                    Text('Destruction : kuay'),
                    Text('Intensity : kuay'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/safety');
          if (index == 2) Navigator.pushReplacementNamed(context, '/setting');
        },
      ),
    );
  }
}

