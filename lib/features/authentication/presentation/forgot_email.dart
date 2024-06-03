import 'package:flutter/material.dart';

class ForgotEmailView extends StatelessWidget {
  const ForgotEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          'Forgot Email',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
