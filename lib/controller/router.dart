import 'package:go_router/go_router.dart';
import 'package:artgallery/views/home_page.dart';
import 'package:artgallery/views/authentication/login_page.dart';
import 'package:artgallery/views/authentication/registration_page.dart';
import 'package:artgallery/views/profile_page.dart';
import 'package:artgallery/views/settings_page.dart';
import 'package:artgallery/views/splash_page.dart';
import 'package:artgallery/utilities/directoryrouter.dart';
import 'package:artgallery/views/edit_profile_page.dart'; // Import EditProfilePage

final GoRouter router = GoRouter(
  initialLocation: DirectoryRouter.splashpage, // Use the constant from DirectoryRouter
  routes: [
    GoRoute(
      name: DirectoryRouter.homepage,
      path: DirectoryRouter.homepage,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.profilepage,
      path: DirectoryRouter.profilepage,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const ProfilePage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.editprofilepage,
      path: DirectoryRouter.editprofilepage,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?; // Cast extra to Map<String, dynamic>?
        return NoTransitionPage<void>(
          key: state.pageKey,
          child: EditProfilePage(
            currentName: extra?['currentName'] ?? '',
            currentBio: extra?['currentBio'] ?? '',
            currentProfilePictureUrl: extra?['currentProfilePictureUrl'] ?? '',
          ),
        );
      },
    ),
    GoRoute(
      name: DirectoryRouter.settingspage,
      path: DirectoryRouter.settingspage,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.loginpage,
      path: DirectoryRouter.loginpage,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.registrationpage,
      path: DirectoryRouter.registrationpage,
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const RegistrationPage(),
      ),
    ),
    GoRoute(
      name: DirectoryRouter.splashpage,
      path: DirectoryRouter.splashpage,
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
