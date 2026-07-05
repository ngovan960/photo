import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/gallery/presentation/providers/gallery_provider.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(galleryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Chọn ảnh', style: AppTypography.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: galleryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, ref, galleryState),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, GalleryState state) {
    if (state.imageBytes != null) {
      return _buildImagePreview(context, ref, state);
    }

    return _buildPickerOptions(context, ref);
  }

  Widget _buildPickerOptions(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 80,
              color: AppColors.gray400,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Chọn ảnh từ thư viện',
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Chọn ảnh selfie hoặc ảnh có sẵn để tạo ảnh thẻ',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => ref.read(galleryProvider.notifier).pickImage(),
                icon: const Icon(Icons.photo_library),
                label: const Text('Chọn từ thư viện'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(galleryProvider.notifier).takePhoto(),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Chụp ảnh mới'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, WidgetRef ref, GalleryState state) {
    return Column(
      children: [
        // Image preview
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.screenPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              border: Border.all(color: AppColors.gray200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              child: Image.memory(
                state.imageBytes!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // Action buttons
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(galleryProvider.notifier).clearSelection(),
                  child: const Text('Chọn lại'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to country picker with image
                    context.push('/countries');
                  },
                  child: const Text('Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
