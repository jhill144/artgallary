import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artgallery/views/home_page.dart';
import 'package:artgallery/views/profile_page.dart';
import 'package:artgallery/views/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation:
      "/home", // Should eventually be "/login" when that is implemented
  routes: [
    GoRoute(
      name: '/home',
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: '/profile',
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      name: '/settings',
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
