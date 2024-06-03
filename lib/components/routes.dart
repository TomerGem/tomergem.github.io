import 'package:flutter/material.dart';
import 'package:landing_page/features/authentication/presentation/authentication_view.dart';
import 'package:landing_page/features/authentication/presentation/forgot_email.dart';
import 'package:landing_page/features/authentication/presentation/forgot_password.dart';
import 'package:landing_page/features/authentication/presentation/password_view.dart';
import 'package:landing_page/features/authentication/presentation/rejected_view.dart';
import 'package:landing_page/features/authentication/presentation/signup_view.dart';
import 'package:landing_page/features/user_dashboard/presentation/dashboard.dart';
// import 'package:landing_page/pages/home_page.dart';

// Path: landing_page/lib/components/themes.dart

const initialRoute = '/home';

final Map<String, WidgetBuilder> routes = {
  // '/': (context) => const AuthenticationView(),
  // '/home': (context) => const AuthenticationView(),
  '/rejected': (context) => const RejectedView(),
  '/password': (context) => const PasswordView(),
  '/dashboard': (context) => const UserDashboard(),
  '/forgot_email': (context) => const ForgotEmailView(),
  '/forgot_password': (context) => const ForgotPasswordView(),
  '/login': (context) => const AuthenticationView(),
  '/signup': (context) => const SignupView(),
};
