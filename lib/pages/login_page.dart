import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Stack(
        children: [
          // ---------- Main content ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/alert');
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          offset: Offset(2, 2),
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C2C2C),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2C2C2C),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE0E0E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2C2C2C),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2C2C2C),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE0E0E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2C2C2C),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Forgot Password'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          color: Colors.black26,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------- Top-right icon (policy.png) ----------
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Privacy Policy'),
                    content: const Text(
                      'This app collects location data to provide accurate earthquake alerts, '
                          'even when the app is closed or not in use. Your personal data will not be '
                          'shared with any third parties. By continuing, you agree to our privacy policy.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Image.asset(
                'assets/images/policy.png',
                width: 70,
                height: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
