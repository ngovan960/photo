import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

class CountryLocalDataSource {
  static const String _boxName = 'countries';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  // Load from embedded JSON
  Future<List<Country>> loadFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/countries/countries.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Country.fromJson(json)).toList();
  }

  // Cache country data
  Future<void> cacheCountries(List<Country> countries) async {
    for (final country in countries) {
      await _box.put(country.code, {
        'code': country.code,
        'name': country.name,
        'nameEn': country.nameEn,
        'region': country.region,
        'documents': country.documents.map((d) => {
          'id': d.id,
          'name': d.name,
          'widthMm': d.widthMm,
          'heightMm': d.heightMm,
          'allowedBackgrounds': d.allowedBackgrounds,
          'requirements': d.requirements,
          'faceRatio': {
            'min': d.faceRatio.min,
            'max': d.faceRatio.max,
            'minEye': d.faceRatio.minEye,
            'maxEye': d.faceRatio.maxEye,
          },
        }).toList(),
      });
    }
  }

  // Load from cache
  List<Country> loadFromCache() {
    final countries = <Country>[];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        final map = Map<String, dynamic>.from(data);
        countries.add(Country.fromJson(map));
      }
    }
    return countries;
  }

  // Get country by code
  Country? getCountryByCode(String code) {
    final data = _box.get(code);
    if (data == null) return null;
    return Country.fromJson(Map<String, dynamic>.from(data));
  }

  // Clear cache
  Future<void> clearCache() async {
    await _box.clear();
  }
}
