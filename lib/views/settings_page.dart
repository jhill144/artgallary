import 'package:artgallery/utilities/directoryrouter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:artgallery/utilities/navigation_menu.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.goNamed(DirectoryRouter.loginpage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  _signOut(context);
                },
                child: const Text('Sign Out'))
          ],
        ),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 2),
    );
  }
}
