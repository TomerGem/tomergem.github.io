import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';

class PasswordField extends ConsumerStatefulWidget {
  const PasswordField({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends ConsumerState<PasswordField> {
  final passwordController = TextEditingController();
  var _obscureText = true; // Set the initial value of obscureText
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_updatePassword);
  }

  @override
  void dispose() {
    passwordController.removeListener(_updatePassword);
    passwordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    ref.read(passwordProvider.notifier).state = passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType
          .visiblePassword, // Set the controller for the text field
      obscureText: _obscureText,
      autocorrect: false,
      // suffixIcon: widget.suffixIcon, // Use the defined suffixIcon parameter
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter password',
        errorText: _isValid ? null : 'Invalid password',
        prefixIcon: const Icon(Icons.password),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle the value of obscureText
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        setState(() {
          _isValid = value.isEmpty ||
              value.length >= 8; // Check if password is at least 8 characters
        });
      },
      onEditingComplete: () {
        if (_isValid) {
          // Password is valid, do something
        } else {
          // Password is not valid, handle the error
        }
      },
    );
  }
}
