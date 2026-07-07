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

    final backgroundColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF);
    final cardColor = isDark ? const Color(0xFF1D2438) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF004AC6),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF004AC6),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: dividerColor.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAZU_WPCKYYDn30TriH5Jsss5nMpLrLV95YtR8X58pFaGfTIXpvNGwUf_bSmcARonZOuhgPdtBUGl3pv7ua6GQ_KuGSBmxd6RU89zhnu7706W5-OOpya1jXegQZk8u78TqDvB80Jb3jYsmOB3OX8A2EwtYjkhJQNPH8XjLx-MFqEXugiiwLoW5r2FH8eAJlthw4jBhJlQCfruQvanGzcfiC8LXTB29iOy6U70gYOpaeI-ug0v9aM6slXfB8tqypYR33xVxboUtOXCU',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alex Johnson',
                              style: TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'alex.j@lumina.com',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // General Section
              _buildSectionHeader(context, 'General'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      trailing: settings.language == 'en' ? 'English (US)' : settings.language,
                      isDark: isDark,
                      onTap: () => _showLanguagePicker(context),
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: isDark ? Icons.dark_mode : Icons.light_mode,
                      title: 'Dark Mode',
                      trailingWidget: Switch(
                        value: isDark,
                        onChanged: (value) {
                          ref.read(themeProvider.notifier).toggleTheme();
                          ref.read(settingsProvider.notifier).updateTheme(value ? 'dark' : 'light');
                        },
                        activeColor: const Color(0xFF004AC6),
                      ),
                      isDark: isDark,
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      trailingWidget: Switch(
                        value: settings.notificationsEnabled,
                        onChanged: (value) => ref.read(settingsProvider.notifier).updateNotifications(value),
                        activeColor: const Color(0xFF004AC6),
                      ),
                      isDark: isDark,
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.lock,
                      title: 'App Lock',
                      trailingWidget: Switch(
                        value: settings.biometricLockEnabled,
                        onChanged: (value) async {
                          if (value) {
                            final authenticated = await BiometricService.authenticate();
                            if (!authenticated) return;
                          }
                          ref.read(settingsProvider.notifier).updateBiometricLock(value);
                        },
                        activeColor: const Color(0xFF004AC6),
                      ),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Photos Section
              _buildSectionHeader(context, 'Photos'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.auto_delete,
                      title: 'Auto-delete',
                      trailing: _getAutoDeleteLabel(settings.autoDeleteDays),
                      isDark: isDark,
                      onTap: () => _showAutoDeletePicker(context),
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.storage,
                      title: 'Cache Size',
                      trailing: cacheState.cacheSizeFormatted,
                      isDark: isDark,
                      onTap: () => _showCacheDialog(context),
                    ),
                  ],
                ),
              ),

              // Privacy Section
              _buildSectionHeader(context, 'Privacy'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.analytics,
                      title: 'Analytics',
                      trailingWidget: Switch(
                        value: settings.analyticsEnabled,
                        onChanged: (value) => ref.read(settingsProvider.notifier).updateAnalytics(value),
                        activeColor: const Color(0xFF004AC6),
                      ),
                      isDark: isDark,
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.bug_report,
                      title: 'Crash Reports',
                      trailingWidget: Switch(
                        value: settings.crashReportsEnabled,
                        onChanged: (value) => ref.read(settingsProvider.notifier).updateCrashReports(value),
                        activeColor: const Color(0xFF004AC6),
                      ),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Subscription Section
              _buildSectionHeader(context, 'Subscription'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004AC6),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF004AC6).withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CURRENT PLAN',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                subscriptionState.isPro ? 'Pro Membership' : 'Free Trial',
                                style: const TextStyle(
                                  fontFamily: 'Hanken Grotesk',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              subscriptionState.isPro ? 'ACTIVE' : 'INACTIVE',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unlock all premium photo filters and unlimited secure file storage.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/paywall'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF004AC6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Manage Plan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // About Section
              _buildSectionHeader(context, 'About'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.info,
                      title: 'Version',
                      trailing: '2.4.0',
                      isDark: isDark,
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.gavel,
                      title: 'Terms of Service',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.mail,
                      title: 'Contact Us',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    Divider(height: 1, color: dividerColor),
                    _buildSettingsTile(
                      icon: Icons.delete_forever,
                      title: 'Xoá tất cả dữ liệu',
                      isDark: isDark,
                      onTap: () => _showDeleteAllDialog(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'LUMINA MOBILE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: isDark ? Colors.white30 : const Color(0xFF004AC6).withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Developed with excellence • 2024',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2020) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF333535) : const Color(0xFFC3C6D7),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.document_scanner,
              label: 'Scan',
              isActive: false,
              isDark: isDark,
              onTap: () => context.push('/countries'),
            ),
            _buildNavItem(
              icon: Icons.photo_library,
              label: 'Photos',
              isActive: false,
              isDark: isDark,
              onTap: () => context.push('/history'),
            ),
            _buildNavItem(
              icon: Icons.folder,
              label: 'Files',
              isActive: false,
              isDark: isDark,
              onTap: () => context.push('/history'),
            ),
            _buildNavItem(
              icon: Icons.settings,
              label: 'Settings',
              isActive: true,
              isDark: isDark,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: isDark ? Colors.white70 : const Color(0xFF004AC6),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? trailing,
    Widget? trailingWidget,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white70 : const Color(0xFF505F76),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else if (trailing != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailing,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? Colors.white70 : const Color(0xFF737686),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Color(0xFF737686),
                  ),
                ],
              )
            else
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF737686),
              ),
          ],
        ),
      ),
    );
  }

  String _getAutoDeleteLabel(String days) {
    switch (days) {
      case 'off': return 'Off';
      case '1': return '1 day';
      case '7': return '7 days';
      case '30': return '30 days';
      default: return '7 days';
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final currentLang = ref.read(settingsProvider).language;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...[
              ('en', 'English (US)'),
              ('vi', 'Tiếng Việt'),
              ('ja', '日本語'),
              ('ko', '한국어'),
              ('zh', '中文'),
            ].map((lang) => ListTile(
                  title: Text(lang.$2),
                  trailing: currentLang == lang.$1
                      ? const Icon(Icons.check, color: Color(0xFF004AC6))
                      : null,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Auto-delete Original Photos',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...[
              ('off', 'Off'),
              ('1', '1 day'),
              ('7', '7 days'),
              ('30', '30 days'),
            ].map((option) => ListTile(
                  title: Text(option.$2),
                  trailing: currentDays == option.$1
                      ? const Icon(Icons.check, color: Color(0xFF004AC6))
                      : null,
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
        title: const Text('Cache Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Used Space: ${cacheState.cacheSizeFormatted}'),
            Text('Saved Photos: ${cacheState.photoCount}'),
            const SizedBox(height: 8),
            const Text(
              'Limit: 100MB',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cacheManagerProvider.notifier).clearCache();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully.')),
              );
            },
            child: const Text(
              'Clear Cache',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This action is permanent and cannot be undone. All your saved photos and options will be cleared.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cacheManagerProvider.notifier).clearCache();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data has been cleared.')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final activeBgColor = isDark ? const Color(0xFF2E3132) : const Color(0xFF0052FF).withOpacity(0.15);
    final activeTextColor = isDark ? Colors.white : const Color(0xFF003EC7);
    final inactiveTextColor = isDark ? Colors.white38 : const Color(0xFF434656);

    if (isActive) {
      return Material(
        color: activeBgColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: activeTextColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    color: activeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: inactiveTextColor,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                color: inactiveTextColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
