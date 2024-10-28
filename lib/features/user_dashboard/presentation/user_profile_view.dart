import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:landing_page/components/basic_layout.dart';
import 'package:landing_page/features/user_dashboard/presentation/user_profile_page_widget.dart';

// import 'package:landing_page/core/resources/mongo/db_services.dart';

class UserProfileView extends ConsumerStatefulWidget {
  const UserProfileView({super.key});

  @override
  ConsumerState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  Widget build(
    BuildContext context,
  ) {
    user = _auth.currentUser;

    return CommonLayoutView(title: 'User Profile', body: UserProfilePage());
  }
}
