import 'package:flutter/material.dart';

ThemeData get lightThemeData {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 21, 16, 83),
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          Colors.grey,
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.fromLTRB(40, 10, 40, 10),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

// Define the default dark theme for the app

ThemeData get darkThemeData {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: Colors.indigo,
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 53, 69, 156),
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.indigo,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 21, 16, 83),
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          Colors.grey,
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.fromLTRB(40, 10, 40, 10),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
