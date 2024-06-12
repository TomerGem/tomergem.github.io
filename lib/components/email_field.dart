import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';

class EmailField extends ConsumerStatefulWidget {
  const EmailField({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends ConsumerState<EmailField> {
  final emailController = TextEditingController();
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateEmail);
  }

  @override
  void dispose() {
    emailController.removeListener(_updateEmail);
    emailController.dispose();
    super.dispose();
  }

  void _updateEmail() {
    ref.read(emailProvider.notifier).state = emailController.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter email',
        errorText: _isValid ? null : 'Invalid email',
        prefixIcon: const Icon(Icons.email),
      ),
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        setState(() {
          _isValid = EmailValidator.validate(value) || value.isEmpty;
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

void correctEmail(BuildContext context, String email) {
  if (!EmailValidator.validate(email)) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Email'),
          content: const Text('Please enter a valid email address.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
