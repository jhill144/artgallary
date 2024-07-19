import 'package:go_router/go_router.dart';
import 'package:artgallery/views/home_page.dart';
import 'package:artgallery/views/authentication/login_page.dart';
import 'package:artgallery/views/authentication/registration_page.dart';
import 'package:artgallery/views/profile_page.dart';
import 'package:artgallery/views/settings_page.dart';
import 'package:artgallery/views/splash_page.dart';
import 'package:artgallery/utilities/directoryrouter.dart';

final GoRouter router = GoRouter(
  initialLocation:
      "/splash", // Should eventually be "/login" when that is implemented
  routes: [
    GoRoute(
      name: DirectoryRouter.homepage,
      path: '/home',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.profilepage,
      path: '/profile',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const ProfilePage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.settingspage,
      path: '/settings',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.loginpage,
      path: '/login',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.registrationpage,
      path: '/registration',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const RegistrationPage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.splashpage,
      path: '/splash',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const SplashPage(
          '',
          title: '',
        ),
      ),
    ),
  ],
);
