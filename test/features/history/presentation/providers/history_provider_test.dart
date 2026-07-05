import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/history/presentation/providers/history_provider.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';

void main() {
  group('HistoryState', () {
    test('should have default values', () {
      const state = HistoryState();

      expect(state.photos, isEmpty);
      expect(state.isLoading, false);
    });

    test('should copy with new values', () {
      const state = HistoryState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.photos, isEmpty);
    });
  });

  group('HistoryNotifier', () {
    test('should add photo', () {
      final notifier = HistoryNotifier();
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      );

      notifier.addPhoto(photo);

      expect(notifier.state.photos.length, 1);
      expect(notifier.state.photos.first.id, '1');
    });

    test('should remove photo', () {
      final notifier = HistoryNotifier();
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      );

      notifier.addPhoto(photo);
      notifier.removePhoto('1');

      expect(notifier.state.photos.isEmpty, true);
    });

    test('should get photo by id', () {
      final notifier = HistoryNotifier();
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      );

      notifier.addPhoto(photo);
      final result = notifier.getPhotoById('1');

      expect(result, isNotNull);
      expect(result!.id, '1');
    });

    test('should return null for non-existent id', () {
      final notifier = HistoryNotifier();
      final result = notifier.getPhotoById('999');

      expect(result, isNull);
    });

    test('should get photos by country', () {
      final notifier = HistoryNotifier();
      notifier.addPhoto(Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      ));
      notifier.addPhoto(Photo(
        id: '2',
        countryCode: 'JP',
        documentId: 'jp_passport',
        createdAt: DateTime(2026, 1, 2),
      ));
      notifier.addPhoto(Photo(
        id: '3',
        countryCode: 'VN',
        documentId: 'vn_passport',
        createdAt: DateTime(2026, 1, 3),
      ));

      final vnPhotos = notifier.getPhotosByCountry('VN');

      expect(vnPhotos.length, 2);
    });

    test('should get saved countries', () {
      final notifier = HistoryNotifier();
      notifier.addPhoto(Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      ));
      notifier.addPhoto(Photo(
        id: '2',
        countryCode: 'JP',
        documentId: 'jp_passport',
        createdAt: DateTime(2026, 1, 2),
      ));

      final countries = notifier.savedCountries;

      expect(countries.length, 2);
      expect(countries.contains('VN'), true);
      expect(countries.contains('JP'), true);
    });
  });
}
