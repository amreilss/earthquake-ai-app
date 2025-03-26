import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'First Name')),
            TextField(decoration: InputDecoration(labelText: 'Last Name')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(decoration: InputDecoration(labelText: 'Username')),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
      ),
    );
  }
}