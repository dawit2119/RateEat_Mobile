import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';

void main() {
  group('NearByItemResponse', () {
    const tId = 'item123';
    const tName = 'Test Item';
    const tImageUri = 'https://example.com/image.jpg';

    const fullResponse = NearByItemResponse(
      id: tId,
      name: tName,
      imageUri: tImageUri,
    );
    const nullResponse = NearByItemResponse();

    test('should be a subclass of Equatable', () {
      expect(fullResponse, isA<Equatable>());
    });

    group('constructor', () {
      test('should create instance with all properties', () {
        expect(fullResponse.id, tId);
        expect(fullResponse.name, tName);
        expect(fullResponse.imageUri, tImageUri);
      });

      test('should create instance with null properties when not provided', () {
        expect(nullResponse.id, isNull);
        expect(nullResponse.name, isNull);
        expect(nullResponse.imageUri, isNull);
      });
    });

    group('props', () {
      test('should return correct list of properties', () {
        expect(fullResponse.props, [tId, tName, tImageUri]);
      });

      test('should return list with null values when properties are null', () {
        expect(nullResponse.props, [null, null, null]);
      });
    });

    group('stringify', () {
      test('should return true', () {
        expect(fullResponse.stringify, isTrue);
        expect(nullResponse.stringify, isTrue);
      });
    });

    group('equality', () {
      test('should be equal when all properties match', () {
        const identicalResponse = NearByItemResponse(
          id: tId,
          name: tName,
          imageUri: tImageUri,
        );

        expect(fullResponse, equals(identicalResponse));
        expect(fullResponse.hashCode, identicalResponse.hashCode);
      });

      test('should not be equal when properties differ', () {
        const differentId = NearByItemResponse(
          id: 'item456',
          name: tName,
          imageUri: tImageUri,
        );
        const differentName = NearByItemResponse(
          id: tId,
          name: 'Different Item',
          imageUri: tImageUri,
        );
        const differentImageUri = NearByItemResponse(
          id: tId,
          name: tName,
          imageUri: 'https://different.com/image.jpg',
        );

        expect(fullResponse, isNot(equals(differentId)));
        expect(fullResponse, isNot(equals(differentName)));
        expect(fullResponse, isNot(equals(differentImageUri)));
      });

      test('should be equal when all properties are null', () {
        const anotherNullResponse = NearByItemResponse();

        expect(nullResponse, equals(anotherNullResponse));
        expect(nullResponse.hashCode, anotherNullResponse.hashCode);
      });

      test(
          'should not be equal when some properties are null and others aren\'t',
          () {
        const partialResponse = NearByItemResponse(
          id: tId,
        );

        expect(fullResponse, isNot(equals(partialResponse)));
        expect(nullResponse, isNot(equals(partialResponse)));
      });
    });
  });
}
