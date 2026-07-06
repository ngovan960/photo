import 'package:flutter/material.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class ErrorState extends StatelessWidget {
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const ErrorState({
    super.key,
    this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (title != null)
              Text(
                title!,
                style: AppTypography.h3.copyWith(
                  color: AppColors.gray700,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
