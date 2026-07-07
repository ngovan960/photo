import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isDark ? AppDarkColors.surface : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                  border: Border.all(
                    color: isDark ? AppDarkColors.border : Colors.transparent,
                  ),
                ),
                child: Icon(
                  Icons.photo_camera,
                  size: 50,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Title
              Text(
                'Photo ID',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              // Subtitle
              Text(
                'Ảnh thẻ chuẩn quốc tế',
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Tagline
              Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: isDark ? AppDarkColors.surface : AppColors.gray50,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  border: Border.all(
                    color: isDark ? AppDarkColors.border : Colors.transparent,
                  ),
                ),
                child: Text(
                  'Tạo ảnh thẻ chuẩn chỉ trong 30 giây',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              // CTA Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/onboarding/permissions'),
                  child: const Text('Bắt đầu'),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              // Login link
              TextButton(
                onPressed: () {},
                child: Text(
                  'Đã có tài khoản? Đăng nhập',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
