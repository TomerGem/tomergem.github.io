import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/presentation/providers/auth_state_provider.dart';

class PasswordField extends ConsumerStatefulWidget {
  // final TextEditingController? controller;

  const PasswordField({super.key});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends ConsumerState<PasswordField> {
  final passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_updatePassword);
  }

  bool _validatePassword(String value) {
    return (value.length >= 8 || value.isEmpty);
  }

  void _updatePassword() {
    ref.read(passwordProvider.notifier).state = passwordController.text;
  }

  @override
  void dispose() {
    passwordController.removeListener(_updatePassword);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: _isValid ? null : 'Password too short',
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        prefixIcon: const Icon(Icons.lock),
      ),
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        setState(() {
          _isValid = _validatePassword(value) || value.isEmpty;
        });
      },
      onEditingComplete: () {
        if (_isValid) {
          // Email is valid, do something
        } else {
          // Email is not valid, handle the error
        }
      },
    );
  }
}
