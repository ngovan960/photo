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

  @override
  Widget build(BuildContext context) {
    final groupedAsync = ref.watch(groupedCountriesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Chọn quốc gia',
          style: AppTypography.h2.copyWith(color: AppColors.gray900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Tìm quốc gia...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray400,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.gray500),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Country list
          Expanded(
            child: groupedAsync.when(
              data: (grouped) {
                if (grouped.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppColors.gray400),
                        const SizedBox(height: AppSpacing.base),
                        Text(
                          'Không tìm thấy quốc gia',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  itemCount: _getGroupedItemCount(grouped),
                  itemBuilder: (context, index) {
                    final result = _getGroupedItem(grouped, index);

                    if (result.isHeader) {
                      return Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
                        child: Text(
                          regionDisplayNames[result.region] ?? result.region,
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                      );
                    }

                    final country = result.country!;
                    return _CountryTile(
                      country: country,
                      onTap: () {
                        ref.read(selectedCountryProvider.notifier).state = country;
                        context.push('/document/${country.code}');
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Lỗi: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getGroupedItemCount(Map<String, List<Country>> grouped) {
    int count = 0;
    for (final entry in grouped.entries) {
      count += 1 + entry.value.length; // header + items
    }
    return count;
  }

  _GroupedItemResult _getGroupedItem(Map<String, List<Country>> grouped, int index) {
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

class _CountryTile extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;

  const _CountryTile({
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(
        country.flagEmoji,
        style: const TextStyle(fontSize: 28),
      ),
      title: Text(
        country.name,
        style: AppTypography.bodyLarge,
      ),
      subtitle: Text(
        country.nameEn,
        style: AppTypography.caption,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.gray400,
      ),
      onTap: onTap,
    );
  }
}
