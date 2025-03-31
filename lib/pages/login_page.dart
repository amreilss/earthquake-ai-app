import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _showPolicyBeforeSignIn(BuildContext context) async {
    bool accepted = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFFDF5E6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
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
                      children: [
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'InriaSerif',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                onPressed: () {
                  accepted = true;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1642E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
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
      ),
    );

    if (accepted) {
      await _signInWithGoogle(context);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      print('🔁 เรียก _signInWithGoogle แล้ว');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('❌ ผู้ใช้ยกเลิกการล็อกอิน');
        return;
      }

      print('✅ ลงชื่อเข้าใช้ Google สำเร็จ: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      print('✅ ลงชื่อเข้าใช้ Firebase สำเร็จ');

      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      print('✅ Firebase idToken: $idToken');

      // ส่ง token ไป backend
      final response = await http.post(
        Uri.parse('https://api.earthquakeai.site/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        print("🎉 Login success! Response from API: $userData");

        Navigator.pushReplacementNamed(context, '/alert');
      } else {
        throw Exception("Login failed with backend: ${response.body}");
      }

    } catch (e) {
      print('🔥 เกิดข้อผิดพลาด: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', width: 200),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Image.asset('assets/images/google.png', width: 24),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    elevation: 5,
                  ),
                  onPressed: () => _showPolicyBeforeSignIn(context),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => _showPolicyBeforeSignIn(context),
              child: Image.asset(
                'assets/images/policy.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
