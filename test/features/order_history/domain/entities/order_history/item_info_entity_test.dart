import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/entities/order_history/item_info_entity.dart';

void main() {
  group('ItemInfoEntity', () {
    const item = ItemInfoEntity(
      name: 'Laptop',
      price: 1500,
      imageUrl: 'https://example.com/laptop.png',
    );

    test('toMap should return correct map', () {
      final expectedMap = {
        'name': 'Laptop',
        'price': 1500,
        'image_url': 'https://example.com/laptop.png',
      };

      expect(item.toMap(), expectedMap);
    });

    test('toJson should return correct JSON', () {
      final expectedJson =
          '{"name":"Laptop","price":1500,"image_url":"https://example.com/laptop.png"}';

      expect(item.toJson(), expectedJson);
    });

    test('should support value equality', () {
      const item1 = ItemInfoEntity(
        name: 'Laptop',
        price: 1500,
        imageUrl: 'https://example.com/laptop.png',
      );

      const item2 = ItemInfoEntity(
        name: 'Laptop',
        price: 1500,
        imageUrl: 'https://example.com/laptop.png',
      );

      expect(item1, equals(item2));
    });

    test('should return correct props', () {
      expect(item.props, ['Laptop', 1500, 'https://example.com/laptop.png']);
    });
  });
}
