import 'package:flutter/material.dart';
import 'package:landing_page/components/password_field.dart';
import 'package:landing_page/components/snackbar_util.dart';
// import 'package:landing_page/features/authentication/domain/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView> {
  TextEditingController passwordController = TextEditingController();
  // ignore: unused_field
  bool _isPasswordValid =
      false; // Track if password is valid to enable "Next" button

  // @override
  // void initState() {
  //   super.initState();
  //   if (ref.watch<String>(emailProvider).isEmpty) {
  //     //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //     //       Navigator.pushReplacementNamed(context, '/login');
  //     print('Email is empty');
  //   } else {
  //     print('Email is not empty');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(passwordProvider, (previous, next) {
      setState(() {
        _isPasswordValid = validatePassword(next);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Entry'),
      ),
      body: Center(
        child: Container(
          width: 500, // Adjust the width as needed
          height: 250, // Adjust the height as needed
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
              color: Colors.indigo[800]),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/enducloud_logo_s.png',
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    'Welcome',
                    style: TextStyle(fontSize: 30),
                  ),
                  const Text(
                    'to the EnduCloud MVP Trial!',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // height: 120,
                    width: 250,
                    child: Form(
                      child: Column(
                        children: [
                          const PasswordField(),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, '/forgot_password');
                                },
                                child: const Text(
                                  'Forgot Password?',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // AuthService().loginWithEmailAndPassword(
                                  //     context: context,
                                  //     email: 'email',
                                  //     password: 'password');

                                  // ToDo - Add user/password validation
                                  // Navigator.pushNamed(context, '/dashboard');
                                  // onPressed: _isPasswordValid
                                  //     ? () {
                                  //         Navigator.pushNamed(
                                  //             context, '/dashboard');
                                  //       }
                                  //       : null,
                                  showSnackbar(context,
                                      'User and password does not match. Please try again.');
                                },
                                child: const Text('Next'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkPasswordValid() {
    // Update state based on text field content
    setState(() {
      _isPasswordValid = validatePassword(passwordController.text);
    });
  }

  bool validatePassword(String password) {
    return (password.length >= 8);
  }
}
