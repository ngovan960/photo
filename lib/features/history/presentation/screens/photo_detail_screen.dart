import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/history/presentation/providers/history_provider.dart';
import 'package:photo_id/features/export/data/export_service.dart';
import 'package:photo_id/features/export/presentation/screens/export_screen.dart';

class PhotoDetailScreen extends ConsumerWidget {
  final String photoId;

  const PhotoDetailScreen({
    super.key,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyProvider);
    final photo = historyState.photos.where((p) => p.id == photoId).firstOrNull;

    if (photo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Không tìm thấy ảnh'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          '${photo.countryCode.toUpperCase()} - ${photo.documentId.split('_').last.toUpperCase()}',
          style: AppTypography.h2.copyWith(color: AppColors.gray900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(historyProvider.notifier).removePhoto(photo.id);
              context.pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo preview
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                child: photo.processedBytes != null
                    ? Image.memory(photo.processedBytes!)
                    : photo.originalBytes != null
                        ? Image.memory(photo.originalBytes!)
                        : Container(
                            height: 300,
                            color: AppColors.gray100,
                            child: const Icon(Icons.photo, size: 64, color: AppColors.gray400),
                          ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Photo info
            _InfoRow(label: 'Quốc gia', value: photo.countryCode.toUpperCase()),
            _InfoRow(label: 'Giấy tờ', value: photo.documentId.split('_').last.toUpperCase()),
            _InfoRow(label: 'Điểm', value: '${photo.qualityScore}/100'),
            _InfoRow(
              label: 'Ngày tạo',
              value: '${photo.createdAt.day}/${photo.createdAt.month}/${photo.createdAt.year}',
            ),

            const SizedBox(height: AppSpacing.lg),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final imageBytes = photo.processedBytes ?? photo.originalBytes;
                      if (imageBytes == null) return;

                      final service = ExportService();
                      await service.exportPhoto(
                        imageBytes: imageBytes,
                        format: ExportFormat.jpeg,
                        layout: ExportLayout.single,
                        paperSize: PaperSize.fourBySix,
                        fileName: '${photo.id}_export',
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã lưu ảnh!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Lưu'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final imageBytes = photo.processedBytes ?? photo.originalBytes;
                      if (imageBytes == null) return;

                      final service = ExportService();
                      final filePath = await service.exportPhoto(
                        imageBytes: imageBytes,
                        format: ExportFormat.jpeg,
                        layout: ExportLayout.single,
                        paperSize: PaperSize.fourBySix,
                        fileName: '${photo.id}_share',
                      );

                      await service.sharePhoto(filePath);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Chia sẻ'),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: AppTypography.bodyMedium.copyWith(color: AppColors.gray600)),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
