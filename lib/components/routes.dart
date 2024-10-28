import 'package:go_router/go_router.dart';
import 'package:landing_page/features/admin/Presentation/connectivity_utils_view.dart';
import 'package:landing_page/features/authentication/presentation/login_view.dart';
import 'package:landing_page/features/authentication/presentation/forgot_password_view.dart';
import 'package:landing_page/features/authentication/presentation/providers/auth_state_provider.dart';
import 'package:landing_page/features/authentication/presentation/signup_view.dart';
import 'package:landing_page/features/linked-applications/presentation/connected_apps_view.dart';
// import 'package:landing_page/features/linked-applications/presentation/garmin_callback_view.dart';
import 'package:landing_page/features/training_design/presentation/workout_editor_view.dart';
import 'package:landing_page/features/training_design/presentation/workout_selection_view.dart';
import 'package:landing_page/features/user_dashboard/presentation/dashboard_view.dart';
import 'package:landing_page/features/user_dashboard/presentation/registration_process_view.dart';
import 'package:landing_page/features/user_dashboard/presentation/user_profile_view.dart';

String initialRoute = '/';

resetInitialRoute(ref) async {
  String newRoute = '/';

  if (ref.watch(isSignedInProvider.notifier).state) {
    initialRoute = '/dashboard';
  } else {
    initialRoute = '/';
  }

  GoRouter(
    initialLocation: newRoute,
    routes: routes,
  );
}

final List<RouteBase> routes = [
  // GoRouter default route
  GoRoute(
    path: '/',
    builder: (context, state) => const AuthenticationView(),
  ),
  GoRoute(
    path: '/dashboard',
    builder: (context, state) => const UserDashboardView(),
  ),
  GoRoute(
    path: '/forgot_password',
    builder: (context, state) => const ForgotPasswordView(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const AuthenticationView(),
  ),
  GoRoute(
    path: '/user_profile',
    builder: (context, state) => const UserProfileView(),
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupView(),
  ),
  GoRoute(
    path: '/connectivity_utils',
    builder: (context, state) => const ConnectivityUtilsView(),
  ),
  GoRoute(
    path: '/registration',
    builder: (context, state) => RegistrationProcessView(),
  ),
  GoRoute(
    path: '/connected_apps',
    builder: (context, state) => const ConnectedAppsView(),
  ),
  GoRoute(
    path: '/workout_selection',
    builder: (context, state) => const WorkoutSelectionView(),
  ),
  GoRoute(
    path: '/workout_editor',
    builder: (context, state) => const WorkoutEditorView(
      exerciseId: -1,
    ),
  ),
];

final GoRouter router = GoRouter(
  initialLocation: initialRoute,
  routes: routes,
);
