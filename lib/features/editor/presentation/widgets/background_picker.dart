import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';

class BackgroundPicker extends ConsumerWidget {
  const BackgroundPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider);

    return Row(
      children: BackgroundColor.values.map((bg) {
        final isSelected = editorState.selectedBackground == bg;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: GestureDetector(
            onTap: () => ref.read(editorProvider.notifier).changeBackground(bg),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: bg.color,
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.gray200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    const Icon(Icons.check, color: AppColors.primary, size: 16),
                  Text(
                    bg.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: bg == BackgroundColor.white
                          ? AppColors.gray700
                          : AppColors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
