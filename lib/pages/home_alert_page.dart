// 🚨 lib/pages/home_alert_page.dart (ออกแบบตาม UI ที่แนบ)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAlertPage extends StatelessWidget {
  const HomeAlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Alert ⚠️',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset('asset/images/logo.png', height: 50),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your area',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      image: AssetImage('asset/images/komhua.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Notification',
                    style: TextStyle(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/safety');
          if (index == 2) Navigator.pushReplacementNamed(context, '/setting');
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('asset/images/safty.svg', height: 28),
            label: 'Safety',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('asset/images/alert.svg', height: 28),
            label: 'Alert',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('asset/images/setting.svg', height: 28),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
