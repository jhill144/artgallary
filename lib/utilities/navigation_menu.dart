import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationMenu extends StatelessWidget {
  final int currentIndex;

  const NavigationMenu({required this.currentIndex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            context.goNamed('/home');
            break;
          case 1:
            context.goNamed('/profile');
            break;
          case 2:
            context.goNamed('/settings');
            break;
        }
      },
    );
  }
}
