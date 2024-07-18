import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artgallery/utilities/directoryrouter.dart';

class NavigationMenu extends StatelessWidget {
  final int currentIndex;

  const NavigationMenu({required this.currentIndex, super.key});

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
            context.goNamed(DirectoryRouter.homepage);
            break;
          case 1:
            context.goNamed(DirectoryRouter.profilepage);
            break;
          case 2:
            context.goNamed(DirectoryRouter.settingspage);
            break;
        }
      },
    );
  }
}
