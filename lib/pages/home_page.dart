import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 20),
              const Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: signIn,
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
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
}
