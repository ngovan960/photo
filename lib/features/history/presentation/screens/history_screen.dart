import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/history/presentation/providers/history_provider.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        title: Text(
          'Lịch sử',
          style: AppTypography.h2.copyWith(color: AppColors.gray900),
        ),
      ),
      body: historyState.photos.isEmpty
          ? _buildEmptyState(context)
          : _buildPhotoGrid(context, ref, historyState.photos),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library_outlined, size: 64, color: AppColors.gray400),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Lịch sử trống',
            style: AppTypography.h3.copyWith(color: AppColors.gray600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ảnh đã tạo sẽ hiển thị ở đây',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, WidgetRef ref, List<Photo> photos) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.itemGap,
        crossAxisSpacing: AppSpacing.itemGap,
        childAspectRatio: 0.75,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return _PhotoGridItem(
          photo: photo,
          onTap: () => context.push('/photo/${photo.id}'),
          onDelete: () => ref.read(historyProvider.notifier).removePhoto(photo.id),
        );
      },
    );
  }
}

class _PhotoGridItem extends StatelessWidget {
  final Photo photo;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PhotoGridItem({
    required this.photo,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo thumbnail
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppBorderRadius.md),
                  ),
                ),
                child: photo.processedBytes != null
                    ? Image.memory(photo.processedBytes!, fit: BoxFit.cover)
                    : photo.originalBytes != null
                        ? Image.memory(photo.originalBytes!, fit: BoxFit.cover)
                        : const Icon(Icons.photo, size: 48, color: AppColors.gray400),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.countryCode.toUpperCase(),
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    photo.documentId.split('_').last.toUpperCase(),
                    style: AppTypography.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
