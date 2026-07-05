import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

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
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Title
              Text(
                'Cần quyền truy cập Camera',
                style: AppTypography.h1.copyWith(
                  color: AppColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.base),
              // Description
              Text(
                'App cần camera để chụp ảnh thẻ.\n'
                'Ảnh được xử lý 100% trên thiết bị,\n'
                'không gửi lên server.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.gray600,
                ),
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
                style: AppTypography.caption.copyWith(
                  color: AppColors.gray400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
