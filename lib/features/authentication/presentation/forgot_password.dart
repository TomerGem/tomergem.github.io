import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          // 'Login Rejected',
          'Lost Password',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
