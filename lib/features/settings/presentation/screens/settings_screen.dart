import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/core/theme/theme_provider.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';
import 'package:photo_id/core/cache/cache_manager.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _selectedLanguage = 'English';
  String _autoDeleteDays = '7 ngày';
  bool _notifications = true;
  bool _biometricLock = false;
  bool _analytics = true;
  bool _crashReports = true;

  @override
  void initState() {
    super.initState();
    // Load cache info
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheManagerProvider.notifier).loadCacheInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final themeMode = ref.watch(themeProvider);
    final cacheState = ref.watch(cacheManagerProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: AppTypography.h2),
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
              trailing: _selectedLanguage,
              onTap: () => _showLanguagePicker(context),
            ),
            _SettingsTile(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Giao diện',
              trailingWidget: Switch(
                value: isDark,
                onChanged: (value) => ref.read(themeProvider.notifier).toggleTheme(),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              trailingWidget: Switch(
                value: _notifications,
                onChanged: (value) => setState(() => _notifications = value),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Khóa app',
              trailingWidget: Switch(
                value: _biometricLock,
                onChanged: (value) => setState(() => _biometricLock = value),
                activeColor: AppColors.primary,
              ),
            ),

            // Photos section
            _SectionHeader(title: 'Ảnh'),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Tự xoá ảnh gốc',
              trailing: _autoDeleteDays,
              onTap: () => _showAutoDeletePicker(context),
            ),
            _SettingsTile(
              icon: Icons.folder_outlined,
              title: 'Album mặc định',
              trailing: 'Photo ID',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.storage_outlined,
              title: 'Dung lượng cache',
              trailing: cacheState.cacheSizeFormatted,
              onTap: () => _showCacheDialog(context),
            ),

            // Privacy section
            _SectionHeader(title: 'Privacy'),
            _SettingsTile(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              trailingWidget: Switch(
                value: _analytics,
                onChanged: (value) => setState(() => _analytics = value),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.bug_report_outlined,
              title: 'Crash reports',
              trailingWidget: Switch(
                value: _crashReports,
                onChanged: (value) => setState(() => _crashReports = value),
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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chọn ngôn ngữ', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.base),
            ...['English', 'Tiếng Việt', '日本語', '한국어', '中文'].map(
              (lang) => ListTile(
                title: Text(lang),
                trailing: _selectedLanguage == lang
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoDeletePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tự xoá ảnh gốc', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.base),
            ...['Tắt', '1 ngày', '7 ngày', '30 ngày'].map(
              (option) => ListTile(
                title: Text(option),
                trailing: _autoDeleteDays == option
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _autoDeleteDays = option);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCacheDialog(BuildContext context) {
    final cacheState = ref.read(cacheManagerProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dung lượng cache'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dung lượng đã dùng: ${cacheState.cacheSizeFormatted}'),
            Text('Số ảnh đã lưu: ${cacheState.photoCount}'),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Giới hạn: 100MB',
              style: AppTypography.bodySmall.copyWith(color: AppColors.gray500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cacheManagerProvider.notifier).clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xoá cache')),
              );
            },
            child: const Text('Xoá cache', style: TextStyle(color: AppColors.error)),
          ),
        ],
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
