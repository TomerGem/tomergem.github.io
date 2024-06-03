import 'package:flutter/material.dart';

class RejectedView extends StatelessWidget {
  const RejectedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Rejected'),
      ),
      body: const Center(
        child: Text(
          textAlign: TextAlign.center,
          // 'Login Rejected',
          'We are sorry, but your login is not registered for the MVP trial. \r\n\r\n Registration for the extended trial will be available soon. \r\n\r\n Thank you for your interest.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
