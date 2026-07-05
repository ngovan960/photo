import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class PhotoCheckScreen extends ConsumerWidget {
  const PhotoCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Kiểm tra ảnh',
          style: AppTypography.h2.copyWith(color: AppColors.gray900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo preview placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 48, color: AppColors.gray400),
                    SizedBox(height: AppSpacing.sm),
                    Text('Chọn ảnh để kiểm tra', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Results placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kết quả', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  _ResultItem(label: 'Kích thước mặt', status: 'pending'),
                  _ResultItem(label: 'Nền', status: 'pending'),
                  _ResultItem(label: 'Ánh sáng', status: 'pending'),
                  _ResultItem(label: 'Biểu cảm', status: 'pending'),
                  _ResultItem(label: 'Độ nét', status: 'pending'),
                  _ResultItem(label: 'Bóng đổ', status: 'pending'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Chụp lại'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Xuất ảnh'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String status; // 'passed', 'warning', 'failed', 'pending'

  const _ResultItem({
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (status) {
      case 'passed':
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'warning':
        icon = Icons.warning;
        color = AppColors.warning;
        break;
      case 'failed':
        icon = Icons.cancel;
        color = AppColors.error;
        break;
      default:
        icon = Icons.radio_button_unchecked;
        color = AppColors.gray400;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
