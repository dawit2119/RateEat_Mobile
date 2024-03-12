import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';

void main() {
  group('RestaurantPhoneNumber', () {
    test('should create an instance with given properties', () {
      const restaurantPhoneNumber = RestaurantPhoneNumber(
        id: '1',
        phoneNumber: '123-456-7890',
      );

      expect(restaurantPhoneNumber.id, '1');
      expect(restaurantPhoneNumber.phoneNumber, '123-456-7890');
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
        'phone_number': '123-456-7890',
      };

      final restaurantPhoneNumber = RestaurantPhoneNumber.fromJson(jsonData);

      expect(restaurantPhoneNumber.id, '1');
      expect(restaurantPhoneNumber.phoneNumber, '123-456-7890');
    });

    test('copyWith should create a new instance with updated values', () {
      const restaurantPhoneNumber = RestaurantPhoneNumber(
        id: '1',
        phoneNumber: '123-456-7890',
      );

      final updatedPhoneNumber =
          restaurantPhoneNumber.copyWith(phoneNumber: '098-765-4321');

      expect(updatedPhoneNumber.id, '1');
      expect(updatedPhoneNumber.phoneNumber, '098-765-4321');
    });

    test('toJson should return a JSON map', () {
      const restaurantPhoneNumber = RestaurantPhoneNumber(
        id: '1',
        phoneNumber: '123-456-7890',
      );

      final jsonMap = restaurantPhoneNumber.toJson();

      expect(jsonMap, {
        'id': '1',
        'phone_number': '123-456-7890',
      });
    });

    test('equality operator should work correctly', () {
      const phoneNumber1 = RestaurantPhoneNumber(
        id: '1',
        phoneNumber: '123-456-7890',
      );
      const phoneNumber2 = RestaurantPhoneNumber(
        id: '1',
        phoneNumber: '123-456-7890',
      );
      const phoneNumber3 = RestaurantPhoneNumber(
        id: '2',
        phoneNumber: '098-765-4321',
      );

      expect(phoneNumber1, phoneNumber2); // They should be equal
      expect(phoneNumber1, isNot(phoneNumber3)); // They should not be equal
    });
  });
}
