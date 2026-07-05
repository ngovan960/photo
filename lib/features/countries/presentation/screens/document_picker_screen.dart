import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/countries/presentation/providers/country_provider.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

class DocumentPickerScreen extends ConsumerWidget {
  final String countryCode;

  const DocumentPickerScreen({
    super.key,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryAsync = ref.watch(countryProvider(countryCode));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          countryCode.toUpperCase(),
          style: AppTypography.h2.copyWith(color: AppColors.gray900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: countryAsync.when(
        data: (country) {
          if (country == null) {
            return const Center(
              child: Text('Không tìm thấy quốc gia'),
            );
          }

          return Column(
            children: [
              // Country header
              Container(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Row(
                  children: [
                    Text(country.flagEmoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(country.name, style: AppTypography.h2),
                          Text(
                            '${country.documents.length} loại giấy tờ',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Document list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  itemCount: country.documents.length,
                  itemBuilder: (context, index) {
                    final document = country.documents[index];
                    return _DocumentCard(
                      document: document,
                      onTap: () {
                        ref.read(selectedDocumentProvider.notifier).state = document;
                        context.push('/camera/${document.id}');
                      },
                    );
                  },
                ),
              ),
              // Info banner
              Container(
                margin: const EdgeInsets.all(AppSpacing.screenPadding),
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Tất cả ảnh được xử lý offline, không upload server',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;

  const _DocumentCard({
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.itemGap),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.description, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(document.name, style: AppTypography.h3),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray400),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Specs
              Row(
                children: [
                  _SpecChip(label: document.sizeString),
                  const SizedBox(width: AppSpacing.xs),
                  _SpecChip(
                    label: 'Nền ${document.allowedBackgrounds.first}',
                    color: AppColors.primarySurface,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Requirements
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: document.requirements.take(3).map((req) {
                  return Text(
                    '• $req',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.gray600,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _SpecChip({
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.gray700,
        ),
      ),
    );
  }
}
