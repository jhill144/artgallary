import 'package:flutter/material.dart';
import 'package:artgallery/utilities/navigation_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(),
      bottomNavigationBar: NavigationMenu(currentIndex: 0),
    );
  }
}
