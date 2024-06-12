// snackbar_util.dart

import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3), // Display for 3 seconds
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
