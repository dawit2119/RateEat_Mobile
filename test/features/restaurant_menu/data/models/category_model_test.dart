import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/category_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

void main() {
  const categoryModel = CategoryModel(
    id: '1',
    name: 'name',
    items: [],
  );

  group('Category Model', () {
    test('should be a subclass of Category', () async {
      expect(categoryModel, isA<CategoryEntity>());
    });

    group('fromJson', () {
      test('should return a valid model from json', () async {
        final result = CategoryModel.fromJson(const {
          "id": "1",
          "name": "name",
          "item": [],
        });

        expect(result, isA<CategoryModel>());
      });
    });

    group('copyWith', () {
      test('should return a copy of the model', () async {
        final result = categoryModel.copyWith(
          id: '1',
          name: 'name',
          items: [],
        );

        expect(result, categoryModel);
      });
    });
  });
}
