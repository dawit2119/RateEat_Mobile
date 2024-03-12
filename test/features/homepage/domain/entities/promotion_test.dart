import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('Promotion Tests', () {
    late Promotion promotion;

    setUp(() {
      promotion = Promotion(
        itemId: '1',
        foodName: 'Pasta',
        restaurantName: 'Italian Bistro',
        imageUrl: 'http://example.com/pasta.jpg',
        discount: 20,
      );
    });

    test('should create a Promotion instance', () {
      expect(promotion.itemId, '1');
      expect(promotion.foodName, 'Pasta');
      expect(promotion.restaurantName, 'Italian Bistro');
      expect(promotion.imageUrl, 'http://example.com/pasta.jpg');
      expect(promotion.discount, 20);
    });

    test('should be equal when all properties are the same', () {
      final anotherPromotion = Promotion(
        itemId: '1',
        foodName: 'Pasta',
        restaurantName: 'Italian Bistro',
        imageUrl: 'http://example.com/pasta.jpg',
        discount: 20,
      );

      expect(promotion, anotherPromotion);
    });

    test('should not be equal when itemId is different', () {
      final differentPromotion = promotion.copyWith(itemId: '2');

      expect(promotion, isNot(equals(differentPromotion)));
    });

    test('should not be equal when foodName is different', () {
      final differentPromotion = promotion.copyWith(foodName: 'Pizza');

      expect(promotion, isNot(equals(differentPromotion)));
    });

    test('copyWith should return a new Promotion instance', () {
      final updatedPromotion = promotion.copyWith(discount: 30);

      expect(updatedPromotion.itemId, promotion.itemId);
      expect(updatedPromotion.foodName, promotion.foodName);
      expect(updatedPromotion.discount, 30);
    });
  });
}
