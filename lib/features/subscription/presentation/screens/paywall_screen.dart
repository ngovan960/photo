import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Nâng cấp Pro',
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, color: AppColors.white, size: 48),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Photo ID Pro',
                    style: AppTypography.h1.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Features
            Text('Tính năng Pro', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            _FeatureItem(icon: Icons.all_inclusive, text: 'Unlimited ảnh'),
            _FeatureItem(icon: Icons.public, text: '50+ quốc gia'),
            _FeatureItem(icon: Icons.palette, text: 'Tất cả nền màu'),
            _FeatureItem(icon: Icons.auto_fix_high, text: 'Retouch & Outfit'),
            _FeatureItem(icon: Icons.photo, text: 'Export PNG không watermark'),
            _FeatureItem(icon: Icons.grid_view, text: 'Batch processing'),
            const SizedBox(height: AppSpacing.lg),

            // Plans
            Text('Chọn gói', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            _PlanCard(
              title: 'Monthly',
              price: '\$2.99/tháng',
              isSelected: false,
              onTap: () => _purchase(context, ref, SubscriptionTier.proMonthly),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PlanCard(
              title: 'Yearly',
              price: '\$19.99/năm',
              badge: 'TIẾT KIỆM 44%',
              isSelected: true,
              onTap: () => _purchase(context, ref, SubscriptionTier.proYearly),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PlanCard(
              title: 'Lifetime',
              price: '\$39.99',
              badge: 'MUA MỘT LẦN DÙNG MÃI',
              isSelected: false,
              onTap: () => _purchase(context, ref, SubscriptionTier.lifetime),
            ),
            const SizedBox(height: AppSpacing.lg),

            // CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _purchase(context, ref, SubscriptionTier.proYearly),
                child: const Text('Nâng cấp ngay'),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            TextButton(
              onPressed: () {},
              child: Text(
                'Hoặc: Xem ads để nhận 1 ảnh miễn phí',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _purchase(BuildContext context, WidgetRef ref, SubscriptionTier tier) {
    ref.read(subscriptionProvider.notifier).upgradeToPro(tier);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã nâng cấp Pro!')),
    );
    context.go('/home');
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.success, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: AppTypography.bodyLarge),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.h3),
                  Text(price, style: AppTypography.bodyLarge),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
