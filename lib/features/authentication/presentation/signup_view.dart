import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landing_page/components/cookies_warning.dart';
import 'package:landing_page/components/email_field.dart';
import 'package:landing_page/components/password_field.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:landing_page/features/authentication/domain/auth_service.dart';
import 'package:landing_page/utilities/firebase_list_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:landing_page/config/env.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService(); // Added DatabaseService
  bool _isCookiesWarningVisible = true;

  void _hideCookiesWarning() {
    setState(() {
      _isCookiesWarningVisible = false;
    });
  }

  Future<void> signupUser(String email, String password) async {
    try {
      List<String> emails = await _dbService.fetchItems('invitation-list');
      if (emails.contains(email)) {
        try {
          final result = await AuthService().signupWithEmailAndPassword(
            context: context,
            email: email.trim(),
            password: password.trim(),
          );
          if (result) {
            ref.read(isSignedInProvider.notifier).state = true;
            context.go('/registration');
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password' || e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid email or password')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.message}')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } else {
        addToWaitingListDialog(context, email);
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error fetching invitation list: $error'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void addToWaitingListDialog(BuildContext context, String email) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email is not in the invitation list'),
          content: Text('You can add your email to the waiting list.'),
          actions: [
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                try {
                  List<String> waitingListItems =
                      await _dbService.fetchItems('waiting-list');

                  if (waitingListItems.contains(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email already in the waiting list.'),
                      ),
                    );
                    context.go('/login');
                  } else {
                    await _dbService.addItemToList('waiting-list', email);
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email added to waiting list.'),
                      ),
                    );
                    sendConfirmationEmail(email);
                    context.go('/login');
                  }
                } catch (error) {
                  context.pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Error adding to waiting list: $error'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendConfirmationEmail(String email) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendConfirmationEmail');
      final response = await callable.call(<String, dynamic>{
        'email': email,
      });
      if (response.data['success']) {
        print('Confirmation email sent to $email');
      } else {
        print('Error sending confirmation email: ${response.data['error']}');
      }
    } catch (error) {
      print('Error sending confirmation email: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(
            '/dashboard'); // Redirect to authentication view if not logged in
      });
      return const SizedBox.shrink(); // Empty widget while redirecting
    }

    bool _validatePassword(String value) {
      return (value.length >= 8 || value.isEmpty);
    }

    ref.listen<String>(emailProvider, (previous, next) {
      setState(() {
        _isEmailValid = EmailValidator.validate(next);
      });
    });

    ref.listen<String>(passwordProvider, (previous, next) {
      setState(() {
        _isPasswordValid = _validatePassword(next);
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            logoImageM,
                            height: 100, // Reduced logo size
                            width: 100, // Reduced logo size
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Welcome!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 245, 227, 69),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'to EnduCloud MVP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.facebook, color: Colors.white),
                          label: const Text(
                            'Sign up using Facebook (Soon)',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            // Handle Facebook login
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF1877F2), // Facebook blue color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            minimumSize: const Size(250, 50),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton.icon(
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            size: 20,
                          ),
                          label: const Text(
                            'Sign up using Google (Soon)',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            // Handle Google login
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            minimumSize: const Size(250, 50),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Or sign up with email',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            const EmailField(),
                            const SizedBox(height: 15),
                            PasswordField(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: ref.watch(rememberMeProvider),
                                  onChanged: (bool? value) {
                                    ref
                                        .read(rememberMeProvider.notifier)
                                        .state = value!;
                                  },
                                ),
                                const Text(
                                  'Remember me',
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                onPressed: _isEmailValid && _isPasswordValid
                                    ? () async {
                                        final email = ref.read(emailProvider);
                                        final password =
                                            ref.read(passwordProvider);
                                        await signupUser(email, password);
                                      }
                                    : null,
                                child: const Text(
                                  'Sign Up',
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  minimumSize: const Size(250, 50),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Already Signed Up?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchURL(privacyUrl);
                          },
                          child: const Text(
                            'Privacy Policy',
                          ),
                        ),
                        const Text(
                          ' | ',
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL(aboutUrl);
                          },
                          child: const Text(
                            'About',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          if (_isCookiesWarningVisible)
            Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: CookiesWarning(onClose: _hideCookiesWarning)),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch $url';
  }
}
