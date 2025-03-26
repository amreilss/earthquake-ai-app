import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {'icon': Icons.groups, 'label': 'Safety'},
      {'icon': Icons.notifications_active, 'label': 'Alert'},
      {'icon': Icons.settings, 'label': 'Setting'},
    ];

    return Container(
      color: const Color(0xFFFDF5E6), // สีพื้นหลัง
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          bool isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF264F9D), // พื้นน้ำเงิน
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    items[index]['icon'],
                    color: const Color(0xFFB7D86F), // สีเขียวอ่อน
                    size: 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  items[index]['label'],
                  style: const TextStyle(
                    fontFamily: 'InriaSerif',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}