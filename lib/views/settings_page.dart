import 'package:flutter/material.dart';
import 'package:artgallery/utilities/navigation_menu.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: const Center(),
      bottomNavigationBar: const NavigationMenu(currentIndex: 2),
    );
  }
}
