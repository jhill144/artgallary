import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artgallery/views/home_page.dart';
import 'package:artgallery/views/profile_page.dart';
import 'package:artgallery/views/settings_page.dart';
import 'package:artgallery/utilities/directoryrouter.dart';

final GoRouter router = GoRouter(
  initialLocation:
      "/home", // Should eventually be "/login" when that is implemented
  routes: [
    GoRoute(
      name: DirectoryRouter.homepage,
      path: '/home',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        name: DirectoryRouter.homepage,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.profilepage,
      path: '/profile',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        name: DirectoryRouter.profilepage,
        child: const ProfilePage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.settingspage,
      path: '/settings',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        name: DirectoryRouter.settingspage,
        child: const SettingsPage(),
      ),
    ),
  ],
);
