import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';
import 'package:photo_id/features/editor/presentation/widgets/background_picker.dart';
import 'package:photo_id/features/editor/presentation/widgets/validation_panel.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String photoId;

  const EditorScreen({
    super.key,
    required this.photoId,
  });

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Chỉnh sửa', style: AppTypography.h2),
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
            _buildPhotoPreview(editorState),
            const SizedBox(height: AppSpacing.lg),
            Text('Nền', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            const BackgroundPicker(),
            const SizedBox(height: AppSpacing.lg),
            Text('Công cụ', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            _buildToolButtons(),
            const SizedBox(height: AppSpacing.lg),
            Text('Validation', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            const ValidationPanel(),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.push('/export/${widget.photoId}'),
                child: const Text('Xuất ảnh'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(EditorState state) {
    if (state.photo?.processedBytes != null) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(color: AppColors.gray200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          child: Image.memory(state.photo!.processedBytes!, fit: BoxFit.contain),
        ),
      );
    }
    if (state.photo?.originalBytes != null) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(color: AppColors.gray200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          child: Image.memory(state.photo!.originalBytes!, fit: BoxFit.contain),
        ),
      );
    }
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Center(child: Icon(Icons.photo, size: 64, color: AppColors.gray400)),
    );
  }

  Widget _buildToolButtons() {
    return Row(
      children: [
        _ToolButton(icon: Icons.crop, label: 'Crop', onTap: () => _onCrop()),
        const SizedBox(width: AppSpacing.sm),
        _ToolButton(icon: Icons.auto_fix_high, label: 'Retouch', isPro: true, onTap: () => _onRetouch()),
        const SizedBox(width: AppSpacing.sm),
        _ToolButton(icon: Icons.checkroom, label: 'Áo', isPro: true, onTap: () => _onOutfit()),
        const SizedBox(width: AppSpacing.sm),
        _ToolButton(icon: Icons.search, label: 'Kiểm tra', onTap: () => _onCheck()),
      ],
    );
  }

  void _onCrop() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Crop tool activated')));
  }

  void _onRetouch() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Retouch applied')));
  }

  void _onOutfit() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chọn trang phục', style: AppTypography.h3),
            const SizedBox(height: 16),
            ListTile(leading: const Icon(Icons.checkroom), title: const Text('Áo sơ mi trắng'), onTap: () => Navigator.pop(ctx)),
            ListTile(leading: const Icon(Icons.checkroom), title: const Text('Vest đen'), onTap: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  void _onCheck() => context.push('/check');
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPro;
  final VoidCallback onTap;

  const _ToolButton({required this.icon, required this.label, this.isPro = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isPro ? AppColors.primarySurface : AppColors.gray50,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            border: Border.all(color: isPro ? AppColors.primary.withOpacity(0.3) : AppColors.gray200),
          ),
          child: Column(
            children: [
              Icon(icon, color: isPro ? AppColors.primary : AppColors.gray700, size: 20),
              const SizedBox(height: 4),
              Text(label, style: AppTypography.labelSmall.copyWith(color: isPro ? AppColors.primary : AppColors.gray700)),
              if (isPro) Text('Pro', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 8)),
            ],
          ),
        ),
      ),
    );
  }
}
