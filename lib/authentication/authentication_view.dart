import 'package:flutter/material.dart';
import 'package:landing_page/components/text_input_field.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView> {
  bool _isSigningIn = false;
  @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     resizeToAvoidBottomInset: false,
  //     body: Column(
  //       children: [
  //         TextInputField(),
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    const privacyUrl = 'https://enducloud.com/legal/privacy.html';
    const aboutUrl = 'https://enducloud.com/static/about.html';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 13, 71, 161),
            Color.fromARGB(255, 21, 101, 192),
            Color.fromARGB(255, 66, 165, 245),
          ],
        ),
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('EnduCloud'),
        //   backgroundColor: Color.fromARGB(0, 0, 0, 0),
        //   elevation: 0,
        // ),
        backgroundColor: Color.fromARGB(0, 5, 17, 129),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  // const Text(
                  //   'EnduCloud',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 40,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
              // const SizedBox(height: 20),
              const Text(
                'EnduCloud',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
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
              SizedBox(
                // height: 120,
                width: 300,
                child: Column(
                  children: [
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email \r\n* entry by invitation only',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          // fontSize: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        disabledBackgroundColor: Colors.white,
                        disabledForegroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),
              // const Text(
              //   'Privacy Policy',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 10,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
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
      ),
    );
  }

  Future signIn() async {
    // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    // await provider.googleLogin();

    //() {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const LoginPage(),
    //         ),
    //       );
    // },
  }

  Future<void> _launchURL(String url) async {
    // const url = 'https://enducloud.com/legal/privacy.html';
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw 'Could not launch $url';
  }
}
