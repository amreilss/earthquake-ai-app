import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Private Policy Content Goes Here...'),
      ),
    );
  }
}