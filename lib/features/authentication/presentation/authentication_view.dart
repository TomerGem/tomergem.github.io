import 'package:flutter/material.dart';
import 'package:landing_page/features/authentication/presentation/rejected_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:landing_page/features/authentication/presentation/email_entry.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool _isSignedIn = false;
  @override
  Widget build(BuildContext context) {
    const privacyUrl = 'https://enducloud.com/legal/privacy.html';
    const aboutUrl = 'https://enducloud.com/static/about.html';
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('EnduCloud'),
      //   backgroundColor: Color.fromARGB(0, 0, 0, 0),
      //   elevation: 0,
      // ),
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

            // Email Entry Widget
            const EmailEntry(),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Sign up for free here',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),

            //ToDo: add other login options: Google, Facebook, Apple, etc.

            const SizedBox(height: 5),

            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _launchURL(privacyUrl),
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      ' | ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _launchURL(aboutUrl),
                      child: const Text(
                        'About',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
}
