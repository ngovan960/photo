import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Title
              Text(
                'Photo ID',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Subtitle
              Text(
                'Ảnh thẻ chuẩn quốc tế',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Tagline
              Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  'Tạo ảnh thẻ chuẩn chỉ trong 30 giây',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
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
