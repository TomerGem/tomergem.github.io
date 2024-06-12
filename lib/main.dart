import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:landing_page/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/features/authentication/presentation/authentication_view.dart';
import 'package:landing_page/components/themes.dart';
import 'package:landing_page/components/routes.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy(); // This is required for Flutter Web to work with Firebase Auth
  runApp(const ProviderScope(child: HomeApp()));
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EnduCloud',
      themeMode: ThemeMode.dark,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      initialRoute: initialRoute,
      routes: routes,
      home: const AuthenticationView(),
    );
    return materialApp;
  }
}
