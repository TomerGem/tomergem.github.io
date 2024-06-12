import 'package:flutter/material.dart';
import 'package:landing_page/features/admin/Presentation/connectivity_utils_view.dart';
import 'package:landing_page/features/authentication/presentation/authentication_view.dart';
import 'package:landing_page/features/authentication/presentation/forgot_email.dart';
import 'package:landing_page/features/authentication/presentation/forgot_password.dart';
import 'package:landing_page/features/authentication/presentation/password_view.dart';
import 'package:landing_page/features/authentication/presentation/template_view.dart';
import 'package:landing_page/features/authentication/presentation/signup_view.dart';
import 'package:landing_page/features/user_dashboard/presentation/dashboard_view.dart';
// import 'package:landing_page/pages/home_page.dart';

// Path: landing_page/lib/components/themes.dart

const initialRoute = '/login';

final Map<String, WidgetBuilder> routes = {
  // '/': (context) => const AuthenticationView(),
  '/dashboard': (context) => const UserDashboardView(),
  '/forgot_email': (context) => const ForgotEmailView(),
  '/forgot_password': (context) => const ForgotPasswordView(),
  '/login': (context) => const AuthenticationView(),
  '/password': (context) => const PasswordView(),
  '/rejected': (context) => const RejectedView(),
  '/signup': (context) => const SignupView(),
  '/connectivity_utils': (context) => const ConnectivityUtilsView(),
};
