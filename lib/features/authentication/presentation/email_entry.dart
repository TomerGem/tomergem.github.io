import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:landing_page/components/standard_text_field.dart';

class EmailEntry extends StatelessWidget {
  const EmailEntry({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    String emailAddress = '';
    return SizedBox(
      // height: 120,
      width: 300,
      child: Form(
        child: Column(
          children: [
            StandardTextField(
                labelText: 'Email \r\n* entry by invitation only',
                controller: emailController),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/forgot_email');
                  },
                  child: const Text(
                    'Forgot Email?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    submitEmail(
                        context, emailController.text.replaceAll('\n', ''));
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
          // ToDo: Add if email exist in database, show "Welcome" screen with
          // "Password" field and "Next" button and "Forgot Password" link.
          // ToDo: Couldn't find your EnduCloud account information message with
          // "Forgot Email" link.
          // ToDo: Add "Don't have an account? Register for free here."
          // ToDo: Create a link "Create Account" to navigate to "Register" screen.
          // ToDo: add other login options: Google, Facebook, Apple, etc.
          // ToDo: Add Check for invitation only email address
          // ToDo: Add "Already have an account" link to "Create Account" screen.
        ),
        onChanged: () {
          // if (kDebugMode) {
          //   print('Form changed: Email: ${emailController.text}');
          // }
          if (emailController.text.contains('\n')) {
            emailAddress = emailController.text.replaceAll('\n', '');
            if (kDebugMode) {
              print('Form submitted: Email: $emailAddress');
            }
            submitEmail(context, emailAddress);
          }
        },
      ),
    );
  }
}

Widget buildEmailEntry(BuildContext context) {
  return const EmailEntry();
}

bool validateEmail(String email) {
  return EmailValidator.validate(email);
}

void submitEmail(BuildContext context, String email) {
  if (kDebugMode) {
    print('Email: $email');
  }
  if (!validateEmail(email)) {
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
  } else {
    Navigator.pushNamed(context, '/password');
  }
}
