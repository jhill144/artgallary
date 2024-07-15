import 'package:flutter/material.dart';
import 'package:artgallery/utilities/navigation_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(),
      bottomNavigationBar: NavigationMenu(currentIndex: 1),
    );
  }
}
