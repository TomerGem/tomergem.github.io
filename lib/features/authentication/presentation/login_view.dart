import 'package:url_launcher/url_launcher.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:landing_page/components/email_field.dart';
import 'package:landing_page/components/password_field.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:landing_page/components/cookies_warning.dart';
import 'package:landing_page/config/env.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isCookiesWarningVisible = true;
  bool _rememberMe = false;

  Future<void> _login(String user, String password) async {
    try {
      // Set persistence based on the "Remember Me" option
      if (_rememberMe) {
        await _auth.setPersistence(Persistence.LOCAL);
      } else {
        await _auth.setPersistence(Persistence.SESSION);
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user,
        password: password,
      );
      context.go('/dashboard');
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
  }

  void _hideCookiesWarning() {
    setState(() {
      _isCookiesWarningVisible = false;
    });
  }

  bool _validatePassword(String value) {
    return (value.length >= 8 || value.isEmpty);
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
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              logoImageM,
                              height: 100,
                              width: 100,
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
                            icon:
                                const Icon(Icons.facebook, color: Colors.white),
                            label: const Text(
                              'Log in using Facebook (Soon)',
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
                              'Log in using Google (Soon)',
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
                          'Or log in with email',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
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
                                          _login(
                                              ref
                                                  .read(emailProvider.notifier)
                                                  .state,
                                              ref
                                                  .read(
                                                      passwordProvider.notifier)
                                                  .state);
                                        }
                                      : null,
                                  child: const Text(
                                    'Log In',
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
                            context.go('/forgot_password');
                          },
                          child: const Text(
                            'Forgot Your Password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            context.go('/signup');
                          },
                          child: const Text(
                            'You can sign up for free here',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Text(
                        ' | ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchURL(aboutUrl);
                        },
                        child: const Text(
                          'About',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
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
