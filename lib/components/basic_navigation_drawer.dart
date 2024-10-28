import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasicNavigationDrawer extends StatelessWidget {
  const BasicNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            // Add an empty tile to create space at the top
            title: Text(''),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              GoRouter.of(context).go('/dashboard');
            },
          ),
          ListTile(
            title: Text('Workouts'),
            onTap: () {
              GoRouter.of(context).go('/workout_selection');
            },
          ),
        ],
      ),
    );
  }
}
