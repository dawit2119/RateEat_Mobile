import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/item_info_model.dart';

void main() {
  group('ItemInfoModel.fromMap', () {
    test('should correctly parse valid data', () {
      final Map<String, dynamic> testData = {
        'name': 'Burger',
        'price': 12,
        'item_images': [
          {'url': 'https://example.com/burger.jpg'}
        ],
      };

      final item = ItemInfoModel.fromMap(testData);

      expect(item.name, 'Burger');
      expect(item.price, 12);
      expect(item.imageUrl, 'https://example.com/burger.jpg');
    });

    test('should handle missing image URL and use default', () {
      final Map<String, dynamic> testData = {
        'name': 'Burger',
        'price': 12,
        'item_images': [],
      };

      final item = ItemInfoModel.fromMap(testData);

      expect(item.imageUrl,
          "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg");
    });

    test('should handle missing item_images field', () {
      final Map<String, dynamic> testData = {
        'name': 'Burger',
        'price': 12,
      };

      final item = ItemInfoModel.fromMap(testData);

      expect(item.imageUrl,
          "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg");
    });

    test('should handle null values gracefully', () {
      final Map<String, dynamic> testData = {
        'name': null,
        'price': null,
        'item_images': null,
      };

      final item = ItemInfoModel.fromMap(testData);

      expect(item.name, isNull);
      expect(item.price, isNull);
      expect(item.imageUrl,
          "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg");
    });
  });
}
