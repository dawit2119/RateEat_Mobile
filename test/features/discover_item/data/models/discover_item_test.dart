import 'package:rateeat_mobile/src/features/discover_item/data/models/discover_item_model.dart';
import 'package:test/test.dart';

void main() {
  group('DiscoverItemModel Tests', () {
    test('Basic creation with all parameters', () {
      final model = DiscoverItemModel(
        maxPrice: 100.0,
        minRating: 4.5,
      );
      expect(model.maxPrice, 100.0);
      expect(model.minRating, 4.5);
    });

    test('Creation with partial parameters', () {
      final model1 = DiscoverItemModel(maxPrice: 50.0);
      expect(model1.maxPrice, 50.0);
      expect(model1.minRating, isNull);

      final model2 = DiscoverItemModel(minRating: 3.0);
      expect(model2.maxPrice, isNull);
      expect(model2.minRating, 3.0);
    });

    test('Creation with no parameters', () {
      final model = DiscoverItemModel();
      expect(model.maxPrice, isNull);
      expect(model.minRating, isNull);
    });

    test('copyWith - updating maxPrice only', () {
      final original = DiscoverItemModel(
        maxPrice: 100.0,
        minRating: 4.0,
      );
      final updated = original.copyWith(maxPrice: 200.0);

      expect(updated.maxPrice, 200.0);
      expect(updated.minRating, 4.0); // Should retain original value
      expect(original.maxPrice, 100.0); // Original should be unchanged
    });

    test('copyWith - updating minRating only', () {
      final original = DiscoverItemModel(
        maxPrice: 100.0,
        minRating: 4.0,
      );
      final updated = original.copyWith(minRating: 5.0);

      expect(updated.maxPrice, 100.0);
      expect(updated.minRating, 5.0);
      expect(original.minRating, 4.0);
    });

    test('copyWith - updating both parameters', () {
      final original = DiscoverItemModel(
        maxPrice: 100.0,
        minRating: 4.0,
      );
      final updated = original.copyWith(
        maxPrice: 200.0,
        minRating: 5.0,
      );

      expect(updated.maxPrice, 200.0);
      expect(updated.minRating, 5.0);
      expect(original.maxPrice, 100.0); // Original should be unchanged
      expect(original.minRating, 4.0); // Original should be unchanged
    });

    test('copyWith - no parameters changes original values', () {
      final original = DiscoverItemModel(
        maxPrice: 100.0,
        minRating: 4.0,
      );
      final updated = original.copyWith();

      expect(updated.maxPrice, 100.0);
      expect(updated.minRating, 4.0);
      expect(updated, isNot(same(original)));
    });
  });
}
