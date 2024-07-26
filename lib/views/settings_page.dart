import 'package:artgallery/utilities/firebase/firebase_auth_services.dart';
import 'package:artgallery/utilities/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:artgallery/utilities/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuthServices _authService = FirebaseAuthServices();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('artists')
          .doc(user.uid)
          .get();
      setState(() {
        _usernameController.text = userDoc['artistUsername'] ?? '';
        _emailController.text = user.email ?? '';
      });
    }
  }

  Future<void> _updateUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('artists')
          .doc(user.uid)
          .update({
        'artistUsername': _usernameController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully')),
      );
    }
  }

  Future<void> _updateEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateEmail(_emailController.text);
        await FirebaseFirestore.instance
            .collection('artists')
            .doc(user.uid)
            .update({
          'artistEmail': _emailController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email: $e')),
        );
      }
    }
  }

  Future<void> _updatePassword() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password: $e')),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('artists')
          .doc(user.uid)
          .delete();
      await user.delete();
      context.go('/splash');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    context.go('/login');
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Update Username'),
              TextField(
                controller: _usernameController,
                decoration:
                    const InputDecoration(hintText: 'Enter new username'),
              ),
              ElevatedButton(
                onPressed: _updateUsername,
                child: const Text('Update Username'),
              ),
              const Divider(height: 20),
              const Text('Update Email'),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Enter new email'),
              ),
              ElevatedButton(
                onPressed: _updateEmail,
                child: const Text('Update Email'),
              ),
              const Divider(height: 20),
              const Text('Update Password'),
              TextField(
                controller: _newPasswordController,
                decoration:
                    const InputDecoration(hintText: 'Enter new password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _updatePassword,
                child: const Text('Update Password'),
              ),
              const Divider(height: 20),
              const Text('Theme'),
              SwitchListTile(
                title: const Text('Dark Theme'),
                value: themeProvider.isDarkTheme,
                onChanged: (value) => _toggleTheme(),
              ),
              const Divider(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _deleteAccount,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete Account'),
                ),
              ),
              const Divider(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _signOut,
                  child: const Text('Sign Out'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavigationMenu(currentIndex: 1),
    );
  }
}
