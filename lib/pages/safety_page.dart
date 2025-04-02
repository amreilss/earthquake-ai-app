import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';


class SafetyPage extends StatelessWidget {
  const SafetyPage({Key? key}) : super(key: key);

  Widget _buildSafetyItem(String imagePath, String label) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalHeight = constraints.maxHeight;
        final double imageHeight = totalHeight * 0.68;
        final double fontSize = totalHeight * 0.11; // ลดขนาดฟอนต์ลงเล็กน้อย

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: imageHeight,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox( // ✅ ปรับขนาดข้อความอัตโนมัติไม่ให้ล้น
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'InriaSerif',
                      fontSize: fontSize.clamp(12.0, 16.0),
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true, // Temp change to force Git detect
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, Color bgColor, List<Map<String, String>> items) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double boxHeight = screenHeight * 0.23;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.008, // ลดระยะแนวตั้งลงเล็กน้อย
      ),
      child: Container(
        height: boxHeight,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items
              .map((item) => Expanded(
            child: _buildSafetyItem(item['image']!, item['label']!),
          ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.13), // ลดความสูง AppBar
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.04, // ลดระยะห่างจากบนสุด
            left: 16,
            right: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Safety',
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/logo.png',
                width: screenHeight * 0.12, // ลดขนาดโลโก้
                height: screenHeight * 0.11,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01), // ลด padding ล่าง
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.005), // ลดช่องว่างบนสุด
            _buildSection(context, const Color(0xFFA3B565), [
              {'image': 'assets/images/drop.png', 'label': 'Drop'},
              {'image': 'assets/images/take_cover.png', 'label': 'Take cover'},
              {'image': 'assets/images/holdon.png', 'label': 'Hold on'},
            ]),
            _buildSection(context, Colors.transparent, [
              {'image': 'assets/images/dont_panic.png', 'label': "Don't panic"},
              {'image': 'assets/images/komhua.png', 'label': 'Drop, Cover,\nHold On'},
              {'image': 'assets/images/pidgas.png', 'label': 'Take off gas\nand electricity'},
            ]),
            _buildSection(context, const Color(0xFFC4C3E3), [
              {'image': 'assets/images/potectyourhead.png', 'label': 'Protect\nyour head'},
              {'image': 'assets/images/nolift.png', 'label': "Don't take\nelevators"},
              {'image': 'assets/images/run.png', 'label': 'Stay away from\nwindows'},
            ]),
          ],
        ),
      ),
    );
  }
}

