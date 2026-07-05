import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:photo_id/features/onboarding/presentation/screens/permissions_screen.dart';
import 'package:photo_id/features/onboarding/presentation/screens/tutorial_screen.dart';
import 'package:photo_id/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/onboarding/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/countries',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Country Picker')),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings')),
        ),
      ),
    ],
  );
}
