import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/countries/presentation/providers/country_provider.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

class CountryPickerScreen extends ConsumerStatefulWidget {
  const CountryPickerScreen({super.key});

  @override
  ConsumerState<CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends ConsumerState<CountryPickerScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const _dialCodes = {
    'US': '+1',
    'GB': '+44',
    'CA': '+1',
    'AR': '+54',
    'BR': '+55',
    'MX': '+52',
    'FR': '+33',
    'DE': '+49',
    'IT': '+39',
    'ES': '+34',
    'CN': '+86',
    'IN': '+91',
    'JP': '+81',
    'KR': '+82',
    'VN': '+84',
  };

  static const _regionDisplayNamesEn = {
    'popular': 'Popular',
    'americas': 'Americas',
    'europe': 'Europe',
    'asia': 'Asia',
    'southeast_asia': 'Asia',
    'east_asia': 'Asia',
    'south_asia': 'Asia',
    'north_america': 'Americas',
    'south_america': 'Americas',
    'africa': 'Africa',
    'oceania': 'Oceania',
  };

  @override
  Widget build(BuildContext context) {
    final groupedAsync = ref.watch(groupedCountriesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF191C1D) : const Color(0xFFF7F9FB);
    final surfaceColor = isDark ? const Color(0xFF1D2022) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF191C1D) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: const Color(0xFF003EC7),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Select Country',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF191C1E),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search input compliant with select_country.html
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 16,
                color: isDark ? Colors.white : const Color(0xFF191C1E),
              ),
              decoration: InputDecoration(
                hintText: 'Search for a country...',
                hintStyle: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 16,
                  color: isDark ? Colors.white60 : const Color(0xFF737688),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF737688),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel, color: Color(0xFF737688)),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF2E3132) : const Color(0xFFECEEF0),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF434656) : const Color(0xFFC3C5D9),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF434656) : const Color(0xFFC3C5D9),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF0052FF),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // Countries List
          Expanded(
            child: groupedAsync.when(
              data: (grouped) {
                if (grouped.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: Color(0xFF737688),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No countries found',
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 16,
                            color: isDark ? Colors.white70 : const Color(0xFF191C1E),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Rewrite grouped regions to match popular, americas, europe, asia
                final mappedGrouped = <String, List<Country>>{};
                
                // If there's no search query, let's create a customPopular group
                final isSearchActive = _searchController.text.isNotEmpty;
                if (!isSearchActive) {
                  // Add popular items: US, GB, CA if they exist in dataset
                  final popularList = <Country>[];
                  final americasList = <Country>[];
                  final europeList = <Country>[];
                  final asiaList = <Country>[];

                  for (final entry in grouped.entries) {
                    for (final country in entry.value) {
                      if (country.code == 'US' || country.code == 'GB' || country.code == 'CA') {
                        popularList.add(country);
                      }
                      
                      final mappedRegion = _regionDisplayNamesEn[country.region] ?? 'Other';
                      if (mappedRegion == 'Americas') {
                        americasList.add(country);
                      } else if (mappedRegion == 'Europe') {
                        europeList.add(country);
                      } else if (mappedRegion == 'Asia') {
                        asiaList.add(country);
                      }
                    }
                  }

                  if (popularList.isNotEmpty) mappedGrouped['popular'] = popularList;
                  if (americasList.isNotEmpty) mappedGrouped['americas'] = americasList;
                  if (europeList.isNotEmpty) mappedGrouped['europe'] = europeList;
                  if (asiaList.isNotEmpty) mappedGrouped['asia'] = asiaList;
                } else {
                  // If searching, just group normally by region using the mappedRegion names
                  for (final entry in grouped.entries) {
                    for (final country in entry.value) {
                      final mappedRegion = country.region.toLowerCase();
                      if (!mappedGrouped.containsKey(mappedRegion)) {
                        mappedGrouped[mappedRegion] = [];
                      }
                      mappedGrouped[mappedRegion]!.add(country);
                    }
                  }
                }

                final keys = mappedGrouped.keys.toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _getMappedGroupedItemCount(mappedGrouped),
                  itemBuilder: (context, index) {
                    final result = _getMappedGroupedItem(mappedGrouped, index);

                    if (result.isHeader) {
                      final regionName = _regionDisplayNamesEn[result.region] ?? result.region.toUpperCase();
                      return Container(
                        width: double.infinity,
                        color: isDark ? const Color(0xFF2E3132) : const Color(0xFFECEEF0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: Text(
                          regionName,
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white70 : const Color(0xFF434656),
                          ),
                        ),
                      );
                    }

                    final country = result.country!;
                    final dialCode = _dialCodes[country.code] ?? '';

                    return Material(
                      color: isDark ? const Color(0xFF191C1D) : Colors.white,
                      child: InkWell(
                        onTap: () {
                          ref.read(selectedCountryProvider.notifier).state = country;
                          context.push('/document/${country.code}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Text(
                                country.flagEmoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  country.nameEn,
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : const Color(0xFF191C1E),
                                  ),
                                ),
                              ),
                              if (dialCode.isNotEmpty)
                                Text(
                                  dialCode,
                                  style: TextStyle(
                                    fontFamily: 'Hanken Grotesk',
                                    fontSize: 14,
                                    color: isDark ? Colors.white60 : const Color(0xFF737688),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2020) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF333535) : const Color(0xFFC3C5D9),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.public,
              label: 'Explorer',
              isActive: true,
              isDark: isDark,
              onTap: () {},
            ),
            _buildNavItem(
              icon: Icons.star,
              label: 'Favorites',
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

  int _getMappedGroupedItemCount(Map<String, List<Country>> grouped) {
    int count = 0;
    for (final entry in grouped.entries) {
      count += 1 + entry.value.length; // header + items
    }
    return count;
  }

  _GroupedItemResult _getMappedGroupedItem(Map<String, List<Country>> grouped, int index) {
    int currentIndex = 0;
    for (final entry in grouped.entries) {
      if (currentIndex == index) {
        return _GroupedItemResult(isHeader: true, region: entry.key);
      }
      currentIndex++;

      for (int i = 0; i < entry.value.length; i++) {
        if (currentIndex == index) {
          return _GroupedItemResult(isHeader: false, country: entry.value[i]);
        }
        currentIndex++;
      }
    }
    return _GroupedItemResult(isHeader: true, region: '');
  }
}

class _GroupedItemResult {
  final bool isHeader;
  final String region;
  final Country? country;

  const _GroupedItemResult({
    required this.isHeader,
    this.region = '',
    this.country,
  });
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
