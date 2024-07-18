import 'package:flutter/material.dart';
import 'package:artgallery/utilities/navigation_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(),
      bottomNavigationBar: const NavigationMenu(currentIndex: 1),
    );
  }
}
