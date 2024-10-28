import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/components/basic_layout.dart';
// import 'package:landing_page/core/resources/mongo/db_services.dart';

class UserDashboardView extends ConsumerStatefulWidget {
  const UserDashboardView({super.key});

  @override
  ConsumerState createState() => _UserDashboardViewState();
}

class _UserDashboardViewState extends ConsumerState<UserDashboardView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(
    BuildContext context,
  ) {
    final user = _auth.currentUser;

    return CommonLayoutView(
        title: 'User Dashboard',
        body: Text('This will be the user dashboard.'));
  }
}
