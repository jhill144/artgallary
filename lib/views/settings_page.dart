import 'package:flutter/material.dart';
import 'package:artgallery/utilities/navigation_menu.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(),
      bottomNavigationBar: NavigationMenu(currentIndex: 2),
    );
  }
}
