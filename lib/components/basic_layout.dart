import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:landing_page/components/basic_appbar.dart';
import 'package:landing_page/components/basic_body.dart';
import 'package:landing_page/components/basic_bottom_navigation_bar.dart';
import 'package:landing_page/components/basic_navigation_drawer.dart';
import 'package:landing_page/components/basic_wide_body.dart';

class CommonLayoutView extends ConsumerStatefulWidget {
  final String title; // Add the title parameter
  final Widget body; // Add the body parameter

  const CommonLayoutView({required this.title, required this.body, Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _CommonLayoutViewState();
}

class _CommonLayoutViewState extends ConsumerState<CommonLayoutView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Await the initialization and state check
    User? user = await FirebaseAuth.instance.currentUser;

    // Update the state
    setState(() {
      user = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      user = _auth.currentUser;
      if (user == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context
              .go('/login'); // Redirect to authentication view if not logged in
        });
        return const SizedBox.shrink(); // Empty widget while redirecting
      } else {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Wide screen: Show side panel
            return Scaffold(
              appBar: BasicAppBar(widget: widget),
              body: BasicWideBody(body: widget.body),
              bottomNavigationBar: BasicBottomNavigationBar(),
            );
          } else {
            return Scaffold(
              appBar: BasicAppBar(widget: widget),
              drawer: BasicNavigationDrawer(),
              body: BasicBody(body: widget.body),
              bottomNavigationBar: BasicBottomNavigationBar(),
            );
          }
        });
      }
    }
  }
}
