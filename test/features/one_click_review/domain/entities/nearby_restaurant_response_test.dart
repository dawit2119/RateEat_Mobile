import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';

void main() {
  group('NearByRestaurantResponse', () {
    // Test data
    const tId = 'rest123';
    const tName = 'Test Restaurant';
    const tCurrency = 'USD';

    // Test instances
    const fullResponse = NearByRestaurantResponse(
      id: tId,
      name: tName,
      currency: tCurrency,
    );
    const nullResponse = NearByRestaurantResponse();

    test('should be a subclass of Equatable', () {
      expect(fullResponse, isA<Equatable>());
    });

    group('constructor', () {
      test('should create instance with all properties', () {
        expect(fullResponse.id, tId);
        expect(fullResponse.name, tName);
        expect(fullResponse.currency, tCurrency);
      });

      test('should create instance with null properties when not provided', () {
        expect(nullResponse.id, isNull);
        expect(nullResponse.name, isNull);
        expect(nullResponse.currency, isNull);
      });
    });

    group('props', () {
      test('should return correct list of properties', () {
        expect(fullResponse.props, [tId, tName, tCurrency]);
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
        const identicalResponse = NearByRestaurantResponse(
          id: tId,
          name: tName,
          currency: tCurrency,
        );

        expect(fullResponse, equals(identicalResponse));
        expect(fullResponse.hashCode, identicalResponse.hashCode);
      });

      test('should not be equal when properties differ', () {
        const differentId = NearByRestaurantResponse(
          id: 'rest456',
          name: tName,
          currency: tCurrency,
        );
        const differentName = NearByRestaurantResponse(
          id: tId,
          name: 'Different Restaurant',
          currency: tCurrency,
        );
        const differentCurrency = NearByRestaurantResponse(
          id: tId,
          name: tName,
          currency: 'EUR',
        );

        expect(fullResponse, isNot(equals(differentId)));
        expect(fullResponse, isNot(equals(differentName)));
        expect(fullResponse, isNot(equals(differentCurrency)));
      });

      test('should be equal when all properties are null', () {
        const anotherNullResponse = NearByRestaurantResponse();

        expect(nullResponse, equals(anotherNullResponse));
        expect(nullResponse.hashCode, anotherNullResponse.hashCode);
      });

      test(
          'should not be equal when some properties are null and others aren\'t',
          () {
        const partialResponse = NearByRestaurantResponse(
          id: tId,
        );

        expect(fullResponse, isNot(equals(partialResponse)));
        expect(nullResponse, isNot(equals(partialResponse)));
      });
    });
  });
}
