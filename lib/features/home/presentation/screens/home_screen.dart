import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF191C1D) : const Color(0xFFF8F9FA);
    final surfaceColor = isDark ? const Color(0xFF1D2022) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF191C1D) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.badge,
              color: Color(0xFF005BFF),
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Photo ID',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF005BFF),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: isDark ? Colors.white70 : const Color(0xFF414754),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Actions: Stacked Vertical Buttons
            _buildMainButton(
              context: context,
              icon: Icons.camera_alt,
              title: 'Take Photo',
              backgroundColor: const Color(0xFF1A73E8),
              textColor: Colors.white,
              onTap: () => context.push('/countries'),
            ),
            const SizedBox(height: 12),
            _buildMainButton(
              context: context,
              icon: Icons.image,
              title: 'Choose from Gallery',
              backgroundColor: const Color(0xFF86F898),
              textColor: const Color(0xFF005320),
              onTap: () => context.push('/gallery'),
            ),
            const SizedBox(height: 12),
            _buildMainButton(
              context: context,
              icon: Icons.search,
              title: 'Check Photo',
              backgroundColor: const Color(0xFFFFDFA0),
              textColor: const Color(0xFF261A00),
              onTap: () => context.push('/check'),
            ),
            const SizedBox(height: 24),

            // Recent Photos Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Photos',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF191C1D),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/history'),
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF005BFF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 190,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _RecentPhotoCard(
                    imagePath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBm28ZaA6zv0NRl1FVm3m6ql4Az4v02R2YjiYUGbha9diwBITT6VIzMDQiZpMLZp6k1o8Dd1qpi4gYBnWzYYXC7i1lp7EAGlPS4_OqPHsSzw53Ib0WQmU-dEHa0bwBdMXGQlSLXXief7W6-ixHctsw3kq5h5r7FMiuqQMD6TlcQxKibtGpGHRTRAv57w3qIH6V8iP3ZZ2tZYx9RFXRDAuhXgQ8eGo6a9kCagihximGbsq092UN70ENBmVNpjNZ2R7-cdWjLCG4_gog',
                    documentName: 'Japan Passport',
                    timeAgo: '2 mins ago',
                    statusIcon: Icons.check_circle,
                    statusColor: const Color(0xFF006E2C),
                    onTap: () => context.push('/photo/1'),
                  ),
                  const SizedBox(width: 16),
                  _RecentPhotoCard(
                    imagePath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDbxebh6W0gShy2cE_UZ3IvpXGWo0UKsm5mn8vEAsEO1PQD4aZctpbkvdz5c_hI5RgLhR7USQhNEqNJgJT93dYu0xJnlZQcSV6pvu8xvqZcN1Jw9HeONd5pR908IPaF7W4Y4_-F6IwIGVY96MUWJ6NVbHgaN6TwACfvU3cOU1ysGVnnKYKymm_dhyiVf09GP3-XN9vT5TYsfB_xRvfx_oXDL9w4SP54H7FQLrKI5YmLRGV5ray-tYf5eRI0Ak68DNalvJqpx2j-daY',
                    documentName: 'USA Visa',
                    timeAgo: 'Yesterday',
                    statusIcon: Icons.error,
                    statusColor: const Color(0xFFBA1A1A),
                    onTap: () => context.push('/photo/2'),
                  ),
                  const SizedBox(width: 16),
                  _RecentPhotoCard(
                    imagePath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCq_P7ZdWuPtCNZS2-bD0ZGd-zRXhL_RN0Js1IoRosHdAo1Ni05KeEjcQUEOW6kk7UzbzvbOZojHqIVR_BoIj8tszn-YAJ1YrHbmLAVtdmEKL6sIk8TneHiYTiwdr7tkF18YLFpAFFbOXAhvozptwLmeOgobJh3gWlW57jHI55LG4QVocc5jNK-PrXVcbT8jFens4hL9fQ6BcNbPMJhuz6m9TxWqcSe0keUtfANVYs2y7Gtn2dSu9_1xw-We2Q9MJSgGFAtxjNsNtM',
                    documentName: 'Vietnam ID',
                    timeAgo: '3 days ago',
                    onTap: () => context.push('/photo/3'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Saved Groups Section
            Text(
              'Saved Groups',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF191C1D),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2020) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF333535) : const Color(0xFFE1E3E4)),
              ),
              child: Column(
                children: [
                  _buildSavedGroupItem(
                    title: 'Japan',
                    subtitle: '2 photos • Updated Today',
                    isDark: isDark,
                    onTap: () => context.push('/history'),
                  ),
                  const Divider(height: 1, indent: 64),
                  _buildSavedGroupItem(
                    title: 'Vietnam',
                    subtitle: '1 photo • Updated 2 days ago',
                    isDark: isDark,
                    onTap: () => context.push('/history'),
                  ),
                  const Divider(height: 1, indent: 64),
                  _buildSavedGroupItem(
                    title: 'USA',
                    subtitle: '3 photos • Updated last week',
                    isDark: isDark,
                    onTap: () => context.push('/history'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120), // Spacing for bottom floating container
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Upgrade to Pro Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1A73E8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upgrade to Pro',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Unlock unlimited features and high-res exports.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => context.push('/paywall'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A73E8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Pro',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Navigation Bar
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2020) : const Color(0xFFEDEEEF),
              border: Border(
                top: BorderSide(
                  color: isDark ? const Color(0xFF333535) : const Color(0xFFE1E3E4),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: true,
                  isDark: isDark,
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: Icons.history,
                  label: 'History',
                  isActive: false,
                  isDark: isDark,
                  onTap: () => context.push('/history'),
                ),
                _buildNavItem(
                  icon: Icons.description,
                  label: 'Documents',
                  isActive: false,
                  isDark: isDark,
                  onTap: () => context.push('/countries'),
                ),
                _buildNavItem(
                  icon: Icons.stars,
                  label: 'Pro',
                  isActive: false,
                  isDark: isDark,
                  onTap: () => context.push('/paywall'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: textColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: textColor.withOpacity(0.5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedGroupItem({
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A73E8).withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.folder,
          color: Color(0xFF1A73E8),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF191C1D),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: isDark ? Colors.white60 : const Color(0xFF414754),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Color(0xFF414754),
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
    final activeBgColor = isDark ? const Color(0xFF2E3132) : const Color(0xFF1A73E8);
    final activeTextColor = Colors.white;
    final inactiveTextColor = isDark ? Colors.white38 : const Color(0xFF414754);

    if (isActive) {
      return Material(
        color: activeBgColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
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
                    fontFamily: 'Inter',
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
      borderRadius: BorderRadius.circular(12),
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
                fontFamily: 'Inter',
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

class _RecentPhotoCard extends StatelessWidget {
  final String imagePath;
  final String documentName;
  final String timeAgo;
  final IconData? statusIcon;
  final Color? statusColor;
  final VoidCallback onTap;

  const _RecentPhotoCard({
    required this.imagePath,
    required this.documentName,
    required this.timeAgo,
    this.statusIcon,
    this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 144,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2020) : const Color(0xFFF3F4F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF333535) : const Color(0xFFE1E3E4).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (statusIcon != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: statusColor!.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.flag,
                        size: 16,
                        color: Color(0xFF414754),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          documentName,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF191C1D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: isDark ? Colors.white60 : const Color(0xFF414754).withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
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
