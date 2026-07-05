import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        title: Text(
          'Photo ID',
          style: AppTypography.h2.copyWith(color: AppColors.gray900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.gray700),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions
            _QuickActionCard(
              icon: Icons.camera_alt,
              label: 'Chụp ảnh mới',
              color: AppColors.primary,
              onTap: () => context.push('/countries'),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _QuickActionCard(
              icon: Icons.photo_library,
              label: 'Chọn từ thư viện',
              color: AppColors.success,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _QuickActionCard(
              icon: Icons.search,
              label: 'Kiểm tra ảnh',
              color: AppColors.warning,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // Recent Photos
            Text('Gần đây', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _PhotoCard(
                    countryFlag: '🇯🇵',
                    documentName: 'Passport',
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _PhotoCard(
                    countryFlag: '🇺🇸',
                    documentName: 'Visa',
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _PhotoCard(
                    countryFlag: '🇻🇳',
                    documentName: 'CCCD',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // Saved Groups
            Text('Đã lưu', style: AppTypography.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            _SavedGroupCard(
              countryFlag: '🇯🇵',
              countryName: 'Nhật Bản',
              photoCount: 2,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.itemGap),
            _SavedGroupCard(
              countryFlag: '🇻🇳',
              countryName: 'Việt Nam',
              photoCount: 1,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // Pro Banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: AppColors.white, size: 24),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nâng cấp Pro',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'Unlimited + không watermark',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                    size: 16,
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: AppSpacing.base),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(color: color),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String countryFlag;
  final String documentName;
  final VoidCallback onTap;

  const _PhotoCard({
    required this.countryFlag,
    required this.documentName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(countryFlag, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              documentName,
              style: AppTypography.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedGroupCard extends StatelessWidget {
  final String countryFlag;
  final String countryName;
  final int photoCount;
  final VoidCallback onTap;

  const _SavedGroupCard({
    required this.countryFlag,
    required this.countryName,
    required this.photoCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Text(countryFlag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.sm),
            Text(countryName, style: AppTypography.bodyLarge),
            const Spacer(),
            Text(
              '$photoCount ảnh',
              style: AppTypography.caption,
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
