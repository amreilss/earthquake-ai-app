import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  SignUpPage({super.key});

  Future<void> _handleSignUp(BuildContext context) async {
    final fname = fnameController.text.trim();
    final lname = lnameController.text.trim();
    final email = emailController.text.trim();
    final username = userController.text.trim();
    final password = passController.text.trim();

    if (fname.isEmpty || lname.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // ✅ สมัครผู้ใช้กับ Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // ✅ บันทึกข้อมูลเพิ่มเติมใน Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        "firstName": fname,
        "lastName": lname,
        "email": email,
        "username": username,
      });

      // ✅ ไปหน้า Login หลังสมัครเสร็จ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(),
          settings: RouteSettings(arguments: 'signup_success'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8E2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Image.asset('assets/images/logo.png', height: 210),
              const SizedBox(height: 8),
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'InriaSerif',
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      _buildTextField(fnameController, "First Name"),
                      const SizedBox(height: 10),
                      _buildTextField(lnameController, "Last Name"),
                      const SizedBox(height: 10),
                      _buildTextField(emailController, "Email"),
                      const SizedBox(height: 10),
                      _buildTextField(userController, "Username"),
                      const SizedBox(height: 10),
                      _buildTextField(passController, "Password", obscure: true),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ปุ่ม Sign Up
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => _handleSignUp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5886BA),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'InriaSerif',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ปุ่ม Back to Sign In
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: const Text(
                  "Back to Sign In",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSerif',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 16, fontFamily: 'InriaSerif'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'InriaSerif'),
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}