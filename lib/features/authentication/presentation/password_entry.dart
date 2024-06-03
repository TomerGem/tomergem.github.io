import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/components/hidden_text_field.dart';

class PasswordEntry extends StatelessWidget {
  const PasswordEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    String password = '';
    return SizedBox(
      // height: 120,
      width: 250,
      child: Form(
        child: Column(
          children: [
            HiddenTextField(
                labelText: 'Password', controller: passwordController),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/forgot_password');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    submitPassword(
                        context, passwordController.text.replaceAll('\n', ''));
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
        onChanged: () {
          if (passwordController.text.contains('\n')) {
            password = passwordController.text.replaceAll('\n', '');
            if (kDebugMode) {
              print('Form submitted: Password: $password');
            }
            submitPassword(context, password);
          }
        },
      ),
    );
  }
}

Widget buildPasswordEntry(BuildContext context) {
  return const PasswordEntry();
}

bool validatePassword(String email) {
  // return EmailValidator.validate(email);
  return false; // Replace false with your validation logic
}

void submitPassword(BuildContext context, String password) {
  if (kDebugMode) {
    print('Password: $password');
  }
  if (!validatePassword(password)) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Password'),
          content: const Text('Please enter a valid password.'),
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
  } else {
    Navigator.pushNamed(context, '/dashboard');
  }
}
