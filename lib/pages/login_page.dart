import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _shownSnackbar = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'signup_success' && !_shownSnackbar) {
      _shownSnackbar = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up successful! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  Future<void> _showPolicyBeforeSignIn(BuildContext context) async {
    bool accepted = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFFDF8E2),
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
      await _handleLogin(context);
    }
  }

  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอก Email และ Password")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      Navigator.pushReplacementNamed(context, '/alert');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/logo.png', height: 200),
                const SizedBox(height: 16),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'InriaSerif',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      _buildTextField(emailController, "Email"),
                      const SizedBox(height: 12),
                      _buildTextField(passController, "Password", obscure: true),
                    ],
                  ),
                ),

                Container(
                  width: 300,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'InriaSerif',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => _showPolicyBeforeSignIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5886BA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'InriaSerif',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'InriaSerif',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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