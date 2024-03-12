import 'package:test/test.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

void main() {
  group('RestaurantResult', () {
    test('Creation', () {
      final result = RestaurantResult(id: 'rest1', name: 'Restaurant A');
      expect(result.id, 'rest1');
      expect(result.name, 'Restaurant A');
    });

    test('fromJson', () {
      final json = {'id': 'rest1', 'name': 'Restaurant A'};
      final result = RestaurantResult.fromJson(json);
      expect(result.id, 'rest1');
      expect(result.name, 'Restaurant A');
    });
  });
}
