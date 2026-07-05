import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

enum ExportFormat { jpeg, png }
enum ExportLayout { single, grid4, grid8 }
enum PaperSize { fourBySix, a4, a5 }

class ExportState {
  final ExportFormat format;
  final ExportLayout layout;
  final PaperSize paperSize;

  const ExportState({
    this.format = ExportFormat.jpeg,
    this.layout = ExportLayout.single,
    this.paperSize = PaperSize.fourBySix,
  });

  ExportState copyWith({
    ExportFormat? format,
    ExportLayout? layout,
    PaperSize? paperSize,
  }) {
    return ExportState(
      format: format ?? this.format,
      layout: layout ?? this.layout,
      paperSize: paperSize ?? this.paperSize,
    );
  }
}

class ExportNotifier extends StateNotifier<ExportState> {
  ExportNotifier() : super(const ExportState());

  void setFormat(ExportFormat format) {
    state = state.copyWith(format: format);
  }

  void setLayout(ExportLayout layout) {
    state = state.copyWith(layout: layout);
  }

  void setPaperSize(PaperSize paperSize) {
    state = state.copyWith(paperSize: paperSize);
  }
}

final exportProvider = StateNotifierProvider<ExportNotifier, ExportState>((ref) {
  return ExportNotifier();
});

class ExportScreen extends ConsumerWidget {
  final String photoId;

  const ExportScreen({
    super.key,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Xuất ảnh',
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
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Center(
                child: Icon(Icons.photo, size: 64, color: AppColors.gray400),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Format picker
            Text('Định dạng', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: ExportFormat.values.map((format) {
                final isSelected = exportState.format == format;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(format == ExportFormat.jpeg ? 'JPEG' : 'PNG'),
                    selected: isSelected,
                    onSelected: (_) => ref.read(exportProvider.notifier).setFormat(format),
                    selectedColor: AppColors.primarySurface,
                    labelStyle: AppTypography.labelMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.gray700,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Layout picker
            Text('Layout', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _LayoutOption(
                  icon: Icons.photo,
                  label: 'Đơn',
                  isSelected: exportState.layout == ExportLayout.single,
                  onTap: () => ref.read(exportProvider.notifier).setLayout(ExportLayout.single),
                ),
                const SizedBox(width: AppSpacing.sm),
                _LayoutOption(
                  icon: Icons.grid_view,
                  label: '4 bản',
                  isSelected: exportState.layout == ExportLayout.grid4,
                  onTap: () => ref.read(exportProvider.notifier).setLayout(ExportLayout.grid4),
                ),
                const SizedBox(width: AppSpacing.sm),
                _LayoutOption(
                  icon: Icons.grid_on,
                  label: '8 bản',
                  isSelected: exportState.layout == ExportLayout.grid8,
                  onTap: () => ref.read(exportProvider.notifier).setLayout(ExportLayout.grid8),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Paper size picker
            Text('Kích thước in', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _PaperOption(
                  label: '4x6',
                  isSelected: exportState.paperSize == PaperSize.fourBySix,
                  onTap: () => ref.read(exportProvider.notifier).setPaperSize(PaperSize.fourBySix),
                ),
                const SizedBox(width: AppSpacing.sm),
                _PaperOption(
                  label: 'A4',
                  isSelected: exportState.paperSize == PaperSize.a4,
                  onTap: () => ref.read(exportProvider.notifier).setPaperSize(PaperSize.a4),
                ),
                const SizedBox(width: AppSpacing.sm),
                _PaperOption(
                  label: 'A5',
                  isSelected: exportState.paperSize == PaperSize.a5,
                  onTap: () => ref.read(exportProvider.notifier).setPaperSize(PaperSize.a5),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.save,
                    label: 'Lưu',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã lưu ảnh!')),
                      );
                      context.go('/home');
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.share,
                    label: 'Chia sẻ',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.print,
                    label: 'In',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.copy,
                    label: 'Copy',
                    onTap: () {},
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

class _LayoutOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LayoutOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySurface : AppColors.gray50,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.gray200,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.gray600,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.gray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaperOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaperOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySurface : AppColors.gray50,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.gray200,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.gray700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.gray700, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
