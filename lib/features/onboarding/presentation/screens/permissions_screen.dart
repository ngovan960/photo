import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? AppDarkColors.surface : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  border: Border.all(
                    color: isDark ? AppDarkColors.border : Colors.transparent,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Title
              Text(
                'Cần quyền truy cập Camera',
                style: AppTypography.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.base),
              // Description
              Text(
                'App cần camera để chụp ảnh thẻ.\n'
                'Ảnh được xử lý 100% trên thiết bị,\n'
                'không gửi lên server.',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Allow button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/onboarding/tutorial'),
                  child: const Text('Cho phép truy cập'),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              // Deny button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.push('/onboarding/tutorial'),
                  child: const Text('Không, cảm ơn'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Hint
              Text(
                '💡 Bạn có thể thay đổi trong Settings sau',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
