import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';

class ValidationPanel extends ConsumerWidget {
  const ValidationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider);
    final result = editorState.validationResult;

    if (result == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Text(
          'Nhấn "Kiểm tra" để đánh giá ảnh',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          // Score
          Row(
            children: [
              Text(
                'Điểm: ${result.score}/100',
                style: AppTypography.labelLarge,
              ),
              const Spacer(),
              _ScoreBadge(score: result.score),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          // Check items
          _ValidationItem(
            label: 'Kích thước mặt',
            passed: result.faceSizeOk,
          ),
          _ValidationItem(
            label: 'Nền',
            passed: result.backgroundOk,
          ),
          _ValidationItem(
            label: 'Ánh sáng',
            passed: result.lightingOk,
          ),
          _ValidationItem(
            label: 'Biểu cảm',
            passed: result.expressionOk,
          ),
          _ValidationItem(
            label: 'Độ nét',
            passed: result.sharpnessOk,
          ),
          _ValidationItem(
            label: 'Bóng đổ',
            passed: result.shadowFree,
          ),
          // Errors
          if (result.errors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            ...result.errors.map((error) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.error, color: AppColors.error, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      error,
                      style: AppTypography.caption.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;

  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 80) {
      color = AppColors.success;
    } else if (score >= 50) {
      color = AppColors.warning;
    } else {
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$score',
        style: AppTypography.labelMedium.copyWith(color: color),
      ),
    );
  }
}

class _ValidationItem extends StatelessWidget {
  final String label;
  final bool passed;

  const _ValidationItem({
    required this.label,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: passed ? AppColors.success : AppColors.error,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
