import 'package:flutter/material.dart';
import 'package:landing_page/features/authentication/presentation/password_entry.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Image(
                    image: Image.asset(
                      'assets/images/enducloud_logo_s.png',
                      height: 50,
                      width: 50,
                    ).image,
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
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PasswordEntry(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
