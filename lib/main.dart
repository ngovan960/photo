import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/core/router/app_router.dart';
import 'package:photo_id/core/theme/app_theme.dart';
import 'package:photo_id/core/theme/theme_provider.dart';
import 'package:photo_id/features/subscription/data/firebase_service.dart';
import 'package:photo_id/features/subscription/data/revenue_cat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.init();

  // Initialize RevenueCat
  await RevenueCatService.init('YOUR_REVENUECAT_API_KEY');

  runApp(const ProviderScope(child: PhotoIdApp()));
}

class PhotoIdApp extends ConsumerWidget {
  const PhotoIdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Photo ID',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
