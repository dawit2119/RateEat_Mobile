import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/item_tag.dart';

void main() {
  final itemTag = ItemTag(
    id: '1',
    name: 'name',
  );
  // Test the ItemTag class
  test('ItemTag should be a subclass of ItemTag', () async {
    // assert
    expect(itemTag, isA<ItemTag>());
  });

  group('from json', () {
    test('should return a valid model from map', () async {
      //arrange
      final json = {
        "id": "1",
        "name": "name",
      };
      //act
      final result = ItemTag.fromJson(json);
      // assert
      expect(result, isA<ItemTag>());
    });
  });
}
