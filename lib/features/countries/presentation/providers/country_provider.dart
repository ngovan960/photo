import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';
import 'package:photo_id/features/countries/data/repositories/country_repository.dart';

// Repository provider
final countryRepositoryProvider = Provider<CountryRepository>((ref) {
  return CountryRepository();
});

// Countries list provider
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final repository = ref.watch(countryRepositoryProvider);
  return await repository.getCountries();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered countries provider
final filteredCountriesProvider = FutureProvider<List<Country>>((ref) async {
  final repository = ref.watch(countryRepositoryProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return await repository.getCountries();
  }
  return await repository.searchCountries(query);
});

// Grouped countries provider (by region)
final groupedCountriesProvider = FutureProvider<Map<String, List<Country>>>((ref) async {
  final countries = await ref.watch(filteredCountriesProvider.future);

  final grouped = <String, List<Country>>{};
  for (final country in countries) {
    final region = country.region;
    if (!grouped.containsKey(region)) {
      grouped[region] = [];
    }
    grouped[region]!.add(country);
  }

  return grouped;
});

// Selected country provider
final selectedCountryProvider = StateProvider<Country?>((ref) => null);

// Selected document provider
final selectedDocumentProvider = StateProvider<Document?>((ref) => null);

// Country by code provider
final countryProvider = FutureProvider.family<Country?, String>((ref, code) async {
  final repository = ref.watch(countryRepositoryProvider);
  return await repository.getCountryByCode(code);
});

// Region display names
const regionDisplayNames = {
  'southeast_asia': 'Đông Nam Á',
  'east_asia': 'Đông Á',
  'south_asia': 'Nam Á',
  'europe': 'Châu Âu',
  'north_america': 'Bắc Mỹ',
  'south_america': 'Nam Mỹ',
  'africa': 'Châu Phi',
  'oceania': 'Châu Đại Dương',
};
