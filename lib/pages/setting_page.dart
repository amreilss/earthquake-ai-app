import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

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
                'Setting',
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
                width: screenHeight * 0.12,
                height: screenHeight * 0.11,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Row(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSerif',
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.person, size: 20),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'First Name',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Last Name',
                hintText: 'Last Name',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// ✅ Private policy button with popup
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: const Color(0xFFFDF5E6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCDD9D),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: const SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Private policy',
                                          style: TextStyle(
                                            fontFamily: 'InriaSerif',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'This app respects your privacy.\n\n'
                                            'We collect anonymous usage data to improve your experience. '
                                            'No personal information is shared with third parties.\n\n'
                                            'By using this app, you agree to the terms stated in this policy.',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'InriaSerif',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF1642E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'InriaSerif',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Private policy',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InriaSerif',
                  decoration: TextDecoration.underline,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                ),
              ),
            ),

            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'InriaSerif',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/safety');
          if (index == 1) Navigator.pushReplacementNamed(context, '/alert');
        },
      ),
    );
  }
}
