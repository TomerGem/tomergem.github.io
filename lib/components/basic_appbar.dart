import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:landing_page/components/basic_layout.dart';
import 'package:landing_page/features/authentication/domain/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:landing_page/config/env.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  BasicAppBar({
    super.key,
    required this.widget,
  });

  final CommonLayoutView widget;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // if (GoRouter.of(context).canPop())
          // IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {
          //     if (GoRouter.of(context).canPop()) {
          //       GoRouter.of(context).pop();
          //     } else {
          //       GoRouter.of(context).go('/dashboard');
          //     }
          //   },
          // ),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/dashboard');
            },
            child: Image.asset(
              logoImageS,
              height: 40,
            ),
          ),
          Text('  ' + widget.title),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.upload_file_rounded),
          onPressed: () {
            throw UnimplementedError();
          },
        ),
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              // Empty menu item to create space
              child: Text(''),
            ),
            PopupMenuItem<String>(
              value: '',
              child: Text(_auth.currentUser?.displayName ??
                  _auth.currentUser?.email ??
                  ''),
            ),
            const PopupMenuItem<String>(
              value: 'User profile',
              child: Row(
                children: [
                  Icon(Icons.person),
                  Text('User profile'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Account settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  Text('Account settings'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Connected Apps',
              child: Row(
                children: [
                  Icon(Icons.apps),
                  Text('Connected Apps'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help),
                  SizedBox(width: 8),
                  Text('Help'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Status',
              child: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 8),
                  Text('Status'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'Logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              child: Row(
                children: [
                  Text('Terms of use', style: TextStyle(color: Colors.grey)),
                  Text(' | '),
                  GestureDetector(
                    onTap: () {
                      _launchURL(privacyUrl);
                    },
                    child: Text(
                      'Privacy policy',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(' | '),
                  Text('Security', style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
            const PopupMenuItem<String>(
              child: Row(
                children: [
                  Text(
                    'Copyright © 2023-2024 EnduCloud Ltd.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (String value) {
            switch (value) {
              case 'User profile':
                GoRouter.of(context).go('/user_profile');
                break;
              case 'menu2':
                GoRouter.of(context).go('/menu2');
                break;
              case 'Logout':
                AuthService().signOut();
                GoRouter.of(context).go('/login');
                break;
              case 'Connected Apps':
                GoRouter.of(context).go('/connected_apps');
                break;
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

Future<void> _launchURL(String url) async {
  await canLaunchUrl(Uri.parse(url))
      ? await launchUrl(Uri.parse(url))
      : throw 'Could not launch $url';
}
