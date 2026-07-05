import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

void main() {
  group('Country Model', () {
    test('should parse country from JSON', () {
      final json = {
        'code': 'VN',
        'name': 'Việt Nam',
        'nameEn': 'Vietnam',
        'region': 'southeast_asia',
        'documents': [
          {
            'id': 'vn_cccd',
            'name': 'CCCD',
            'widthMm': 30,
            'heightMm': 40,
            'allowedBackgrounds': ['white'],
            'requirements': ['Nhìn thẳng', 'Không cười'],
            'faceRatio': {
              'min': 0.70,
              'max': 0.80,
              'minEye': 0.60,
              'maxEye': 0.70,
            },
          },
        ],
      };

      final country = Country.fromJson(json);

      expect(country.code, 'VN');
      expect(country.name, 'Việt Nam');
      expect(country.nameEn, 'Vietnam');
      expect(country.region, 'southeast_asia');
      expect(country.documents.length, 1);
      expect(country.documents[0].id, 'vn_cccd');
      expect(country.documents[0].name, 'CCCD');
    });

    test('should generate flag emoji from code', () {
      final country = Country(
        code: 'VN',
        name: 'Việt Nam',
        nameEn: 'Vietnam',
        region: 'southeast_asia',
        documents: [],
      );

      expect(country.flagEmoji, isNotEmpty);
    });

    test('should get size string', () {
      final doc = Document(
        id: 'test',
        name: 'Test',
        widthMm: 35,
        heightMm: 45,
        allowedBackgrounds: ['white'],
        requirements: [],
        faceRatio: const FaceRatioSpec(min: 0.7, max: 0.8, minEye: 0.6, maxEye: 0.7),
      );

      expect(doc.sizeString, '35x45 mm');
    });
  });
}
