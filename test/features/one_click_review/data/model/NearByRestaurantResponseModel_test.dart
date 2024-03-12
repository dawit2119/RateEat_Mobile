import 'dart:convert';
import 'package:test/test.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_response_model.dart';

void main() {
  group('NearByRestaurantResponseModel', () {
    const testId = 'rest_001';
    const testName = 'Test Restaurant';
    const testCurrency = 'USD';

    const testModel = NearByRestaurantResponseModel(
      id: testId,
      name: testName,
      currency: testCurrency,
    );

    final testMap = {
      'id': testId,
      'name': testName,
      'currency': testCurrency,
    };

    test('should be a subclass of NearByRestaurantResponse', () {
      expect(testModel, isA<NearByRestaurantResponse>());
    });

    group('fromMap', () {
      test('should create instance from map correctly', () {
        final result = NearByRestaurantResponseModel.fromMap(testMap);

        expect(result.id, testId);
        expect(result.name, testName);
        expect(result.currency, testCurrency);
      });

      test('should handle null values', () {
        final nullMap = {
          'id': null,
          'name': null,
          'currency': null,
        };

        final result = NearByRestaurantResponseModel.fromMap(nullMap);

        expect(result.id, isNull);
        expect(result.name, isNull);
        expect(result.currency, isNull);
      });
    });

    group('toMap', () {
      test('should convert to map correctly', () {
        final result = testModel.toMap();

        expect(result['id'], testId);
        expect(result['name'], testName);
        expect(result['currency'], testCurrency);
      });
    });

    group('fromJson', () {
      test('should create instance from JSON string', () {
        final jsonString = json.encode(testMap);
        final result = NearByRestaurantResponseModel.fromJson(jsonString);

        expect(result.id, testId);
        expect(result.name, testName);
        expect(result.currency, testCurrency);
      });

      test('should throw FormatException for invalid JSON', () {
        expect(() => NearByRestaurantResponseModel.fromJson('invalid json'),
            throwsA(isA<FormatException>()));
      });
    });

    group('toJson', () {
      test('should convert to JSON string', () {
        final result = testModel.toJson();
        final decoded = json.decode(result) as Map<String, dynamic>;

        expect(decoded['id'], testId);
        expect(decoded['name'], testName);
        expect(decoded['currency'], testCurrency);
      });
    });

    group('copyWith', () {
      test('should create copy with updated values', () {
        final newId = 'rest_002';
        final newName = 'New Restaurant';
        final newCurrency = 'EUR';

        final copy = testModel.copyWith(
          id: newId,
          name: newName,
          currency: newCurrency,
        );

        expect(copy.id, newId);
        expect(copy.name, newName);
        expect(copy.currency, newCurrency);
      });

      test('should keep original values when not specified', () {
        final copy = testModel.copyWith();

        expect(copy.id, testId);
        expect(copy.name, testName);
        expect(copy.currency, testCurrency);
      });
    });

    test('props should return correct list of properties', () {
      expect(testModel.props, [testId, testName, testCurrency]);
    });

    test('stringify should be true', () {
      expect(testModel.stringify, isTrue);
    });
  });
}
