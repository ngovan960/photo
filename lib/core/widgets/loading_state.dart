import 'package:flutter/material.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class LoadingState extends StatelessWidget {
  final String? message;
  final double? progress;

  const LoadingState({
    super.key,
    this.message,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (progress != null)
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  color: AppColors.primary,
                ),
              )
            else
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: AppColors.primary,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            if (message != null)
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
