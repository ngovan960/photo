import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineStorage {
  static const String _countriesBoxName = 'countries';
  static const String _settingsBoxName = 'settings';
  static const String _photosBoxName = 'photos';
  static const String _subscriptionBoxName = 'subscription';

  late Box _countriesBox;
  late Box _settingsBox;
  late Box _photosBox;
  late Box _subscriptionBox;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();
    _countriesBox = await Hive.openBox(_countriesBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _photosBox = await Hive.openBox(_photosBoxName);
    _subscriptionBox = await Hive.openBox(_subscriptionBoxName);

    _initialized = true;
  }

  // Country data
  Future<void> cacheCountryData(String code, Map<String, dynamic> data) async {
    await initialize();
    await _countriesBox.put(code, json.encode(data));
  }

  Map<String, dynamic>? getCountryData(String code) {
    final data = _countriesBox.get(code);
    if (data == null) return null;
    return json.decode(data);
  }

  // Load embedded JSON country data
  Future<List<Map<String, dynamic>>> loadEmbeddedCountryData() async {
    final jsonString = await rootBundle.loadString('assets/countries/countries.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  // Settings
  Future<void> saveSetting(String key, dynamic value) async {
    await initialize();
    await _settingsBox.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  // Photo records
  Future<void> savePhotoRecord(String id, Map<String, dynamic> record) async {
    await initialize();
    await _photosBox.put(id, json.encode(record));
  }

  Map<String, dynamic>? getPhotoRecord(String id) {
    final data = _photosBox.get(id);
    if (data == null) return null;
    return json.decode(data);
  }

  List<Map<String, dynamic>> getAllPhotoRecords() {
    final records = <Map<String, dynamic>>[];
    for (final key in _photosBox.keys) {
      final data = _photosBox.get(key);
      if (data != null) {
        records.add(json.decode(data));
      }
    }
    return records;
  }

  Future<void> deletePhotoRecord(String id) async {
    await initialize();
    await _photosBox.delete(id);
  }

  // Subscription
  Future<void> saveSubscription(Map<String, dynamic> data) async {
    await initialize();
    await _subscriptionBox.put('current', json.encode(data));
  }

  Map<String, dynamic>? getSubscription() {
    final data = _subscriptionBox.get('current');
    if (data == null) return null;
    return json.decode(data);
  }

  // Clear all data
  Future<void> clearAll() async {
    await initialize();
    await _countriesBox.clear();
    await _settingsBox.clear();
    await _photosBox.clear();
    await _subscriptionBox.clear();
  }
}

// Provider
final offlineStorageProvider = Provider<OfflineStorage>((ref) {
  return OfflineStorage();
});
