import 'package:artgallery/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:artgallery/controller/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:artgallery/utilities/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      routerConfig: router,
    );
  }
}
