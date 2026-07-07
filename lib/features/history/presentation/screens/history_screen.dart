import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/history/presentation/providers/history_provider.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const _countryNames = {
    'US': 'United States',
    'GB': 'United Kingdom',
    'CA': 'Canada',
    'AR': 'Argentina',
    'BR': 'Brazil',
    'MX': 'Mexico',
    'FR': 'France',
    'DE': 'Germany',
    'IT': 'Italy',
    'ES': 'Spain',
    'CN': 'China',
    'IN': 'India',
    'JP': 'Japan',
    'KR': 'South Korea',
    'VN': 'Vietnam',
  };

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF);
    final surfaceColor = isDark ? const Color(0xFF1D2438) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF);

    // Filter photos based on search query
    final filteredPhotos = historyState.photos.where((photo) {
      final countryName = (_countryNames[photo.countryCode.toUpperCase()] ?? photo.countryCode).toLowerCase();
      final docName = photo.documentId.toLowerCase();
      final term = _searchQuery.toLowerCase();
      return countryName.contains(term) || docName.contains(term);
    }).toList();

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
          'Photo History',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF004AC6),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: isDark ? Colors.white70 : const Color(0xFF434655),
            onPressed: () {},
          ),
        ],
      ),
      body: historyState.photos.isEmpty
          ? _buildEmptyState(context, isDark)
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF131B2E),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search country or document...',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? Colors.white60 : const Color(0xFF434655).withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF434655),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1D2438) : const Color(0xFFEAEDFF),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Grid/Group list
                Expanded(
                  child: _buildGroupedPhotoList(context, ref, filteredPhotos, isDark, surfaceColor, dividerColor),
                ),
              ],
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
              isActive: true,
              isDark: isDark,
              onTap: () {},
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
              isActive: false,
              isDark: isDark,
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D2438) : const Color(0xFFE2E7FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_library,
                size: 80,
                color: Color(0xFF004AC6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Photos Yet',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF131B2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start your first ID photo scan to see your history here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: isDark ? Colors.white60 : const Color(0xFF434655),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/countries'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AC6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                ),
                child: const Text(
                  'Start Scanning',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedPhotoList(
    BuildContext context,
    WidgetRef ref,
    List<Photo> photos,
    bool isDark,
    Color surfaceColor,
    Color dividerColor,
  ) {
    if (photos.isEmpty) {
      return Center(
        child: Text(
          'No matching photos found',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: isDark ? Colors.white60 : const Color(0xFF434655),
          ),
        ),
      );
    }

    // Group photos by country
    final grouped = <String, List<Photo>>{};
    for (final photo in photos) {
      final countryName = _countryNames[photo.countryCode.toUpperCase()] ?? photo.countryCode.toUpperCase();
      if (!grouped.containsKey(countryName)) {
        grouped[countryName] = [];
      }
      grouped[countryName]!.add(photo);
    }

    final countries = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        final countryPhotos = grouped[country]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    country,
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF131B2E),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1D2438) : const Color(0xFFE2E7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${countryPhotos.length} ${countryPhotos.length == 1 ? 'Photo' : 'Photos'}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : const Color(0xFF434655),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: countryPhotos.length,
                itemBuilder: (context, idx) {
                  final photo = countryPhotos[idx];
                  return Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF131B2E).withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push('/photo/${photo.id}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: photo.processedBytes != null
                                      ? Image.memory(photo.processedBytes!, fit: BoxFit.cover)
                                      : photo.originalBytes != null
                                          ? Image.memory(photo.originalBytes!, fit: BoxFit.cover)
                                          : Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.photo, size: 48, color: Colors.grey),
                                            ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            photo.documentId.split('_').last.toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'Hanken Grotesk',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : const Color(0xFF131B2E),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _formatDate(photo.createdAt),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 10,
                                              color: isDark ? Colors.white60 : const Color(0xFF434655),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                      onPressed: () => _confirmDelete(context, ref, photo.id),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).removePhoto(id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
