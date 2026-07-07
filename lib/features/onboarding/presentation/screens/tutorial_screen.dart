import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentPage = 0;

  final List<_TutorialPage> _pages = [
    _TutorialPage(
      icon: Icons.public,
      title: 'Chọn quốc gia',
      description: 'Chọn quốc gia và loại giấy tờ.\n'
          'App tự load đúng size và yêu cầu.',
    ),
    _TutorialPage(
      icon: Icons.camera_alt,
      title: 'Chụp ảnh selfie',
      description: 'Hướng dẫn pose chuẩn.\n'
          'AI tự detect và căn chỉnh khuôn mặt.',
    ),
    _TutorialPage(
      icon: Icons.check_circle,
      title: 'Xuất ảnh chuẩn',
      description: 'Xuất ảnh JPEG/PNG, sẵn sàng in.\n'
          'Lưu về thiết bị hoặc chia sẻ.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(
                    'Bỏ qua',
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ),
              // Page content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isDark ? AppDarkColors.surface : AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(
                          color: isDark ? AppDarkColors.border : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        _pages[_currentPage].icon,
                        size: 60,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Title
                    Text(
                      _pages[_currentPage].title,
                      style: AppTypography.h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    // Description
                    Text(
                      _pages[_currentPage].description,
                      style: AppTypography.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      setState(() => _currentPage++);
                    } else {
                      context.go('/home');
                    }
                  },
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Tiếp' : 'Bắt đầu',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage
                          ? AppColors.primary
                          : (isDark ? AppDarkColors.border : AppColors.gray300),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialPage {
  final IconData icon;
  final String title;
  final String description;

  const _TutorialPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
