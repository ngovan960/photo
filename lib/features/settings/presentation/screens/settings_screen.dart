import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/core/theme/theme_provider.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTypography.h2,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General section
            _SectionHeader(title: 'Chung'),
            _SettingsTile(
              icon: Icons.language,
              title: 'Ngôn ngữ',
              trailing: 'English',
              onTap: () {},
            ),
            _SettingsTile(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Giao diện',
              trailingWidget: Switch(
                value: isDark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              trailingWidget: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Lock app',
              trailingWidget: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),

            // Photos section
            _SectionHeader(title: 'Ảnh'),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Xoá ảnh gốc',
              trailing: '7 ngày',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.folder_outlined,
              title: 'Album mặc định',
              trailing: 'Photo ID',
              onTap: () {},
            ),

            // Privacy section
            _SectionHeader(title: 'Privacy'),
            _SettingsTile(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              trailingWidget: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.bug_report_outlined,
              title: 'Crash reports',
              trailingWidget: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),

            // Subscription section
            _SectionHeader(title: 'Subscription'),
            _SettingsTile(
              icon: Icons.star_outline,
              title: 'Photo ID Pro',
              trailing: subscriptionState.isPro ? 'Active' : 'Free',
              onTap: () => context.push('/paywall'),
            ),
            _SettingsTile(
              icon: Icons.receipt_outlined,
              title: 'Lịch sử mua hàng',
              onTap: () {},
            ),

            // About section
            _SectionHeader(title: 'About'),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'Phiên bản',
              trailing: '1.0.0',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Điều khoản',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Chính sách bảo mật',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.star,
              title: 'Đánh giá app',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.email_outlined,
              title: 'Liên hệ',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(color: AppColors.gray500),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: AppColors.gray700),
        title: Text(title, style: AppTypography.bodyLarge),
        trailing: trailingWidget ??
            (trailing != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trailing!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.chevron_right, size: 20, color: AppColors.gray400),
                    ],
                  )
                : const Icon(Icons.chevron_right, size: 20, color: AppColors.gray400)),
        onTap: onTap,
      ),
    );
  }
}
