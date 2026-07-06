import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/core/theme/theme_provider.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';
import 'package:photo_id/features/settings/presentation/providers/settings_provider.dart';
import 'package:photo_id/core/cache/cache_manager.dart';
import 'package:photo_id/core/security/biometric_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheManagerProvider.notifier).loadCacheInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final themeMode = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
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
            _SectionHeader(title: 'Chung'),
            _SettingsTile(
              icon: Icons.language,
              title: 'Ngôn ngữ',
              trailing: settings.language == 'en' ? 'English' : settings.language,
              onTap: () => _showLanguagePicker(context),
            ),
            _SettingsTile(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Giao diện',
              trailingWidget: Switch(
                value: isDark,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                  ref.read(settingsProvider.notifier).updateTheme(value ? 'dark' : 'light');
                },
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              trailingWidget: Switch(
                value: settings.notificationsEnabled,
                onChanged: (value) => ref.read(settingsProvider.notifier).updateNotifications(value),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Khóa app',
              trailingWidget: Switch(
                value: settings.biometricLockEnabled,
                onChanged: (value) async {
                  if (value) {
                    final authenticated = await BiometricService.authenticate();
                    if (!authenticated) return;
                  }
                  ref.read(settingsProvider.notifier).updateBiometricLock(value);
                },
                activeColor: AppColors.primary,
              ),
            ),
            _SectionHeader(title: 'Ảnh'),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Tự xoá ảnh gốc',
              trailing: _getAutoDeleteLabel(settings.autoDeleteDays),
              onTap: () => _showAutoDeletePicker(context),
            ),
            _SettingsTile(
              icon: Icons.storage_outlined,
              title: 'Dung lượng cache',
              trailing: cacheState.cacheSizeFormatted,
              onTap: () => _showCacheDialog(context),
            ),
            _SectionHeader(title: 'Privacy'),
            _SettingsTile(
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              trailingWidget: Switch(
                value: settings.analyticsEnabled,
                onChanged: (value) => ref.read(settingsProvider.notifier).updateAnalytics(value),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.bug_report_outlined,
              title: 'Crash reports',
              trailingWidget: Switch(
                value: settings.crashReportsEnabled,
                onChanged: (value) => ref.read(settingsProvider.notifier).updateCrashReports(value),
                activeColor: AppColors.primary,
              ),
            ),
            _SectionHeader(title: 'Subscription'),
            _SettingsTile(
              icon: Icons.star_outline,
              title: 'Photo ID Pro',
              trailing: subscriptionState.isPro ? 'Active' : 'Free',
              onTap: () => context.push('/paywall'),
            ),
            _SectionHeader(title: 'About'),
            _SettingsTile(icon: Icons.info_outline, title: 'Phiên bản', trailing: '1.0.0'),
            _SettingsTile(icon: Icons.description_outlined, title: 'Điều khoản', onTap: () {}),
            _SettingsTile(icon: Icons.privacy_tip_outlined, title: 'Chính sách bảo mật', onTap: () {}),
            _SettingsTile(icon: Icons.star, title: 'Đánh giá app', onTap: () {}),
            _SettingsTile(icon: Icons.email_outlined, title: 'Liên hệ', onTap: () {}),
            _SectionHeader(title: 'Danger Zone'),
            _SettingsTile(icon: Icons.delete_forever, title: 'Xoá tất cả dữ liệu', onTap: () => _showDeleteAllDialog(context)),
          ],
        ),
      ),
    );
  }

  String _getAutoDeleteLabel(String days) {
    switch (days) {
      case 'off': return 'Tắt';
      case '1': return '1 ngày';
      case '7': return '7 ngày';
      case '30': return '30 ngày';
      default: return '7 ngày';
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final currentLang = ref.read(settingsProvider).language;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chọn ngôn ngữ', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.base),
            ...[
              ('en', 'English'), ('vi', 'Tiếng Việt'), ('ja', '日本語'), ('ko', '한국어'), ('zh', '中文'),
            ].map((lang) => ListTile(
                  title: Text(lang.$2),
                  trailing: currentLang == lang.$1 ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(settingsProvider.notifier).updateLanguage(lang.$1);
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showAutoDeletePicker(BuildContext context) {
    final currentDays = ref.read(settingsProvider).autoDeleteDays;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tự xoá ảnh gốc', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.base),
            ...[
              ('off', 'Tắt'), ('1', '1 ngày'), ('7', '7 ngày'), ('30', '30 ngày'),
            ].map((option) => ListTile(
                  title: Text(option.$2),
                  trailing: currentDays == option.$1 ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(settingsProvider.notifier).updateAutoDelete(option.$1);
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showCacheDialog(BuildContext context) {
    final cacheState = ref.read(cacheManagerProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dung lượng cache'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dung lượng đã dùng: ${cacheState.cacheSizeFormatted}'),
            Text('Số ảnh đã lưu: ${cacheState.photoCount}'),
            const SizedBox(height: AppSpacing.base),
            Text('Giới hạn: 100MB', style: AppTypography.bodySmall.copyWith(color: AppColors.gray500)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
          TextButton(
            onPressed: () {
              ref.read(cacheManagerProvider.notifier).clearCache();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá cache')));
            },
            child: const Text('Xoá cache', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá tất cả dữ liệu'),
        content: const Text('Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          TextButton(
            onPressed: () {
              ref.read(cacheManagerProvider.notifier).clearCache();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xoá tất cả dữ liệu')));
            },
            child: const Text('Xoá', style: TextStyle(color: AppColors.error)),
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.lg, AppSpacing.screenPadding, AppSpacing.sm),
      child: Text(title, style: AppTypography.labelLarge.copyWith(color: AppColors.gray500)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.title, this.trailing, this.trailingWidget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        leading: Icon(icon, color: AppColors.gray700),
        title: Text(title, style: AppTypography.bodyLarge),
        trailing: trailingWidget ??
            (trailing != null
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(trailing!, style: AppTypography.bodyMedium.copyWith(color: AppColors.gray500)),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.chevron_right, size: 20, color: AppColors.gray400),
                  ])
                : const Icon(Icons.chevron_right, size: 20, color: AppColors.gray400)),
        onTap: onTap,
      ),
    );
  }
}
