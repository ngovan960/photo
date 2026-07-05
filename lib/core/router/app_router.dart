import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:photo_id/features/onboarding/presentation/screens/permissions_screen.dart';
import 'package:photo_id/features/onboarding/presentation/screens/tutorial_screen.dart';
import 'package:photo_id/features/home/presentation/screens/home_screen.dart';
import 'package:photo_id/features/countries/presentation/screens/country_picker_screen.dart';
import 'package:photo_id/features/countries/presentation/screens/document_picker_screen.dart';
import 'package:photo_id/features/camera/presentation/screens/camera_screen.dart';
import 'package:photo_id/features/editor/presentation/screens/editor_screen.dart';
import 'package:photo_id/features/export/presentation/screens/export_screen.dart';
import 'package:photo_id/features/history/presentation/screens/history_screen.dart';
import 'package:photo_id/features/history/presentation/screens/photo_detail_screen.dart';

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
        builder: (context, state) => const CountryPickerScreen(),
      ),
      GoRoute(
        path: '/document/:countryCode',
        builder: (context, state) => DocumentPickerScreen(
          countryCode: state.pathParameters['countryCode']!,
        ),
      ),
      GoRoute(
        path: '/camera/:documentId',
        builder: (context, state) => CameraScreen(
          documentId: state.pathParameters['documentId']!,
        ),
      ),
      GoRoute(
        path: '/editor/:photoId',
        builder: (context, state) => EditorScreen(
          photoId: state.pathParameters['photoId']!,
        ),
      ),
      GoRoute(
        path: '/export/:photoId',
        builder: (context, state) => ExportScreen(
          photoId: state.pathParameters['photoId']!,
        ),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/photo/:photoId',
        builder: (context, state) => PhotoDetailScreen(
          photoId: state.pathParameters['photoId']!,
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
