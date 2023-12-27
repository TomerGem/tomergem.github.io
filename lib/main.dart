import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:landing_page/authentication/authentication_view.dart';
// import 'package:landing_page/pages/home_page.dart';
import 'package:landing_page/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HomeApp());
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnduCloud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const HomePage(),
      home: const AuthenticationView(),
    );
  }
}
