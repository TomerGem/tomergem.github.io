import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/components/email_field.dart';
import 'package:landing_page/features/authentication/presentation/template_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationViewState createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  bool _isEmailValid = false; // Track if email is valid to enable "Next" button

  @override
  Widget build(BuildContext context) {
    // final emailState = ref.watch(emailProvider);

    const privacyUrl = 'https://enducloud.com/legal/privacy.html';
    const aboutUrl = 'https://enducloud.com/static/about.html';

    ref.listen<String>(emailProvider, (previous, next) {
      setState(() {
        _isEmailValid = EmailValidator.validate(next);
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: Image.asset(
                    'assets/images/enducloud_logo_m.png',
                    height: 200,
                    width: 200,
                  ).image,
                ),
              ],
            ),
            // const SizedBox(height: 20),
            const Column(
              children: [
                Text(
                  'EnduCloud',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Health, Fitness, and Quality of Life',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 5),
            const Text(
              'Coming Soon',
              style: TextStyle(
                color: Color.fromARGB(255, 245, 227, 69),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
                width: 300,
                child: Column(
                  children: [
                    // EmailField(emailController: emailController),
                    const EmailField(),
                    const SizedBox(
                      height: 15,
                    ),
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
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _isEmailValid
                              ? () {
                                  // ToDo perform check to see if mail is in database
                                  Navigator.pushNamed(context, '/password');
                                }
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                )),

            // const SizedBox(width: 300, child: EmailEntry()),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Sign up for free here',
              ),
            ),

            // ToDo: Add if email exist in database, show "Welcome" screen with
            // "Password" field and "Next" button and "Forgot Password" link.
            // ToDo: Couldn't find your EnduCloud account information message with
            // "Forgot Email" link.
            // ToDo: Add "Don't have an account? Register for free here."
            // ToDo: Create a link "Create Account" to navigate to "Register" screen.
            // ToDo: add other login options: Google, Facebook, Apple, etc.
            // ToDo: Add Check for invitation only email address
            // ToDo: Add "Already have an account" link to "Create Account" screen.

            const SizedBox(height: 5),

            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }

  signIn() async {
    // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    // await provider.googleLogin();

    () {
      // ignore: avoid_print
      print('Sign in');
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => PasswordView(),
          builder: (context) => const RejectedView(),
        ),
      );
    };
  }

  Future<void> _launchURL(String url) async {
    // const url = 'https://enducloud.com/legal/privacy.html';
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch $url';
  }

  // void _checkEmailValid() {
  //   // Update state based on text field content
  //   setState(() {
  //     _isEmailValid =
  //         EmailValidator.validate(ref.read(emailProvider.notifier).state);
  //   });
  // }
}
