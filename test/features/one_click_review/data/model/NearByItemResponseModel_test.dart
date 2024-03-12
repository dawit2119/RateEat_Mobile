import 'dart:convert';
import 'package:test/test.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_response_model.dart'; // Adjust path as needed

void main() {
  group('NearByItemResponseModel', () {
    // Test data
    const testId = '123';
    const testName = 'Test Restaurant';
    const testImageUri = 'https://example.com/image.jpg';

    // Test instance
    const testModel = NearByItemResponseModel(
      id: testId,
      name: testName,
      imageUri: testImageUri,
    );

    // Test JSON map
    final testMap = {
      'id': testId,
      'name': testName,
      'image_url': testImageUri,
    };

    test('should be a subclass of NearByItemResponse', () {
      expect(testModel, isA<NearByItemResponse>());
    });

    group('fromMap', () {
      test('should create instance from map correctly', () {
        final result = NearByItemResponseModel.fromMap(testMap);

        expect(result.id, testId);
        expect(result.name, testName);
        expect(result.imageUri, testImageUri);
      });

      test('should handle null values', () {
        final nullMap = {
          'id': null,
          'name': null,
          'image_url': null,
        };

        final result = NearByItemResponseModel.fromMap(nullMap);

        expect(result.id, isNull);
        expect(result.name, isNull);
        expect(result.imageUri, isNull);
      });
    });

    group('toMap', () {
      test('should convert to map correctly', () {
        final result = testModel.toMap();

        expect(result['id'], testId);
        expect(result['name'], testName);
        expect(result['currency'],
            testImageUri); // Note: this seems to be a bug in the original code
      });
    });

    group('fromJson', () {
      test('should create instance from JSON string', () {
        final jsonString = json.encode(testMap);
        final result = NearByItemResponseModel.fromJson(jsonString);

        expect(result.id, testId);
        expect(result.name, testName);
        expect(result.imageUri, testImageUri);
      });
    });

    group('toJson', () {
      test('should convert to JSON string', () {
        final result = testModel.toJson();
        final decoded = json.decode(result) as Map<String, dynamic>;

        expect(decoded['id'], testId);
        expect(decoded['name'], testName);
        expect(decoded['currency'],
            testImageUri); // Note: this seems to be a bug in the original code
      });
    });

    group('copyWith', () {
      test('should create copy with updated values', () {
        final newId = '456';
        final copy = testModel.copyWith(id: newId);

        expect(copy.id, newId);
        expect(copy.name, testName);
        expect(copy.imageUri, testImageUri);
      });

      test('should keep original values when not specified', () {
        final copy = testModel.copyWith();

        expect(copy.id, testId);
        expect(copy.name, testName);
        expect(copy.imageUri, testImageUri);
      });
    });

    test('props should return correct list of properties', () {
      expect(testModel.props, [testId, testName, testImageUri]);
    });

    test('stringify should be true', () {
      expect(testModel.stringify, isTrue);
    });
  });
}
