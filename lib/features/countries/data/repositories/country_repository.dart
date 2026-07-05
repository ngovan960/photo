import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

class CountryRepository {
  List<Country>? _countries;

  Future<List<Country>> getCountries() async {
    if (_countries != null) return _countries!;

    final jsonString = await rootBundle.loadString('assets/countries/countries.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _countries = jsonList.map((json) => Country.fromJson(json)).toList();
    return _countries!;
  }

  Future<Country?> getCountryByCode(String code) async {
    final countries = await getCountries();
    try {
      return countries.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }

  Future<List<Country>> searchCountries(String query) async {
    final countries = await getCountries();
    final lowerQuery = query.toLowerCase();
    return countries.where((c) =>
      c.name.toLowerCase().contains(lowerQuery) ||
      c.nameEn.toLowerCase().contains(lowerQuery) ||
      c.code.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Future<List<Country>> getCountriesByRegion(String region) async {
    final countries = await getCountries();
    return countries.where((c) => c.region == region).toList();
  }

  Future<List<String>> getRegions() async {
    final countries = await getCountries();
    return countries.map((c) => c.region).toSet().toList();
  }
}
