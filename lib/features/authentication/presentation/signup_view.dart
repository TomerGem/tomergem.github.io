import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          'Sign UP',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
