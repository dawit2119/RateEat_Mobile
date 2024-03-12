import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_categories.dart';

import 'add_candidate_item_usecase_test.mocks.dart';

void main() {
  late GetRestaurantMenuCategories getRestaurantMenuCategories;
  late MockRestaurantMenuRepository mockRestaurantMenuRepository;

  setUp(() {
    mockRestaurantMenuRepository = MockRestaurantMenuRepository();
    getRestaurantMenuCategories = GetRestaurantMenuCategories(
      restaurantMenuRepository: mockRestaurantMenuRepository,
    );
  });

  const params = '1';
  const testResponse = [
    RestaurantMenuCategoryModel(
      id: '1',
      name: 'name',
      menuId: '1',
      isApproved: false,
    ),
  ];

  test('should get the restaurant menu categories', () async {
    // arrange
    when(
      mockRestaurantMenuRepository.getRestaurantMenuCategories(
        restaurantId: params,
      ),
    ).thenAnswer(
      (_) async => const Right(testResponse),
    );

    // act
    final result = await getRestaurantMenuCategories(params);
    // assert
    expect(
      result,
      const Right(testResponse),
    );
    verify(
      mockRestaurantMenuRepository.getRestaurantMenuCategories(
        restaurantId: params,
      ),
    );
    verifyNoMoreInteractions(mockRestaurantMenuRepository);
  });
}
