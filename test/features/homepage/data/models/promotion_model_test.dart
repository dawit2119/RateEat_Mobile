import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('PromotionModel Tests', () {
    late PromotionModel promotionModel;

    setUp(() {
      promotionModel = PromotionModel(
        itemId: '123',
        foodName: 'Pizza',
        restaurantName: 'Pizza Place',
        imageUrl: 'http://example.com/image.jpg',
        discount: 20,
      );
    });

    test('should create a PromotionModel instance', () {
      expect(promotionModel.itemId, '123');
      expect(promotionModel.foodName, 'Pizza');
      expect(promotionModel.restaurantName, 'Pizza Place');
      expect(promotionModel.imageUrl, 'http://example.com/image.jpg');
      expect(promotionModel.discount, 20);
    });

    test('should convert PromotionModel to JSON', () {
      final json = promotionModel.toJson();

      expect(json['itemId'], promotionModel.itemId);
      expect(json['foodName'], promotionModel.foodName);
      expect(json['restaurantName'], promotionModel.restaurantName);
      expect(json['imageUrl'], promotionModel.imageUrl);
      expect(json['discount'], promotionModel.discount);
    });

    test('should create PromotionModel from JSON', () {
      final json = {
        'itemId': '456',
        'foodName': 'Burger',
        'restaurantName': 'Burger Joint',
        'imageUrl': 'http://example.com/burger.jpg',
        'discount': 15,
      };

      final newPromotion = PromotionModel.fromJson(json);

      expect(newPromotion.itemId, '456');
      expect(newPromotion.foodName, 'Burger');
      expect(newPromotion.restaurantName, 'Burger Joint');
      expect(newPromotion.imageUrl, 'http://example.com/burger.jpg');
      expect(newPromotion.discount, 15);
    });

    test('should copy PromotionModel with new values', () {
      final updatedPromotion =
          promotionModel.copyWith(foodName: 'Updated Pizza');

      expect(updatedPromotion.itemId, promotionModel.itemId);
      expect(updatedPromotion.foodName, 'Updated Pizza');
      expect(updatedPromotion.restaurantName, promotionModel.restaurantName);
      expect(updatedPromotion.imageUrl, promotionModel.imageUrl);
      expect(updatedPromotion.discount, promotionModel.discount);
    });
  });
}
