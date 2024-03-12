import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/restaurant_category.dart';

void main() {
  const restaurantCategoryModel = RestaurantMenuCategoryModel(
    id: '1',
    name: 'name',
    menuId: '1',
    isApproved: false,
  );

  group('Restaurant Category Model', () {
    test('should be a subclass of RestaurantCategory', () async {
      expect(restaurantCategoryModel, isA<RestaurantCategory>());
    });

    group('fromJson', () {
      test('should return a valid model from json', () async {
        final result = RestaurantMenuCategoryModel.fromJson(const {
          "id": "1",
          "name": "name",
          "menu_id": "1",
          "is_approved": false,
        });

        expect(result, isA<RestaurantMenuCategoryModel>());
      });
    });

    group('copyWith', () {
      test('should return a copy of the model', () async {
        final result = restaurantCategoryModel.copyWith(
          id: '1',
          name: 'name',
          menuId: '1',
          isApproved: false,
        );

        expect(result, restaurantCategoryModel);
      });
    });
  });
}
