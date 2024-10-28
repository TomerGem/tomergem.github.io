import 'package:flutter/material.dart';

ThemeData get lightThemeData {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      surface: Colors.white,
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
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color.fromARGB(255, 21, 16, 83),
        ),
        overlayColor: WidgetStateProperty.all<Color>(
          Colors.grey,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.fromLTRB(40, 10, 40, 10),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
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

final DarkBackground = Color.fromARGB(255, 23, 27, 63);

ThemeData get darkThemeData {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Colors.black45,
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      // backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: DarkBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.indigo
                  .withOpacity(0.5); // Darker blue color when disabled
            }
            return Colors.indigo; // Original blue color when enabled
          },
        ),
        overlayColor: WidgetStateProperty.all<Color>(
          Colors.grey,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.fromLTRB(20, 5, 20, 5),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // Gray color when disabled
            }
            return Colors.white; // White color when enabled
          },
        ),
      ),
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      backgroundColor: Colors.indigo,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(
          Colors.white,
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          Colors.blue,
        ),
        overlayColor: WidgetStateProperty.all<Color>(
          Colors.grey,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.fromLTRB(20, 5, 20, 5),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.white,
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
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 16,
    ),
  );
}
