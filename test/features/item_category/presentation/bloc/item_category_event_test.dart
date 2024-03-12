import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/bloc/item_category_event.dart';

void main() {
  group('SearchFoodCategoryEvent', () {
    test('SearchSubmitted props are correct', () {
      final event = SearchSubmitted(query: 'Fruits', pageNumber: 1);
      expect(event.props, ['Fruits', 1]);
    });

    test('GetCategorySuggestion has correct props', () {
      final event = GetCategorySuggestion();
      expect(event.props, []);
    });
  });

  group('SelectFoodCategoryEvent', () {
    test('SelectFoodCategory props are correct', () {
      final event = SelectFoodCategory(foodCategory: 'Fruits');
      expect(event.props, ['Fruits']);
    });

    test('UnselectFoodCategory props are correct', () {
      final event = UnselectFoodCategory(foodCategory: 'Fruits');
      expect(event.props, ['Fruits']);
    });

    test('CreateNewCategory props are correct', () {
      final event = CreateNewCategory(foodCategory: 'Vegetables');
      expect(event.props, ['Vegetables']);
    });

    test('ResetCategoryEvent has correct props', () {
      final event = ResetCategoryEvent();
      expect(event.props, []);
    });
  });
}
