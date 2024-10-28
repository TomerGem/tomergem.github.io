import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasicBottomNavigationBar extends StatefulWidget {
  const BasicBottomNavigationBar({
    super.key,
  });

  @override
  State<BasicBottomNavigationBar> createState() =>
      _BasicBottomNavigationBarState();
}

class _BasicBottomNavigationBarState extends State<BasicBottomNavigationBar> {
  void _onItemTapped(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });

    switch (index) {
      case 0:
        GoRouter.of(context).go('/dashboard');
        break;
      case 1:
        GoRouter.of(context).go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
