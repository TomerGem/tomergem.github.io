import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:landing_page/components/routes.dart';
import 'package:landing_page/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/components/themes.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:landing_page/utilities/app_initialization.dart';
// import 'package:landing_page/components/deep_link_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await appInitialization();
  usePathUrlStrategy(); // Required for proper routing on web
  runApp(const ProviderScope(child: HomeApp()));
}

class HomeApp extends ConsumerStatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

autoLoginWaiter() async {
  // Place holder for initialization logic
  // await Future.delayed(const Duration(seconds: 1));
  return true;
}

class _HomeAppState extends ConsumerState<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: autoLoginWaiter(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ProviderScope(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'EnduCloud',
                  themeMode: ThemeMode.dark,
                  theme: lightThemeData,
                  darkTheme: darkThemeData,
                  routerDelegate: router.routerDelegate,
                  routeInformationParser: router.routeInformationParser,
                  routeInformationProvider: router.routeInformationProvider,
                ),
                // DeepLinkHandler(), // Add DeepLinkHandler here
              ],
            ),
          ),
        );
      },
    );
  }
}
