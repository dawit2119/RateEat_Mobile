import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_category_items_use_case.dart';

import 'add_candidate_item_usecase_test.mocks.dart';

void main() {
  late GetRestaurantMenuCategoryItemsUseCase
      getRestaurantMenuCategoryItemsUseCase;
  late MockRestaurantMenuRepository mockRestaurantMenuRepository;

  setUp(() {
    mockRestaurantMenuRepository = MockRestaurantMenuRepository();
    getRestaurantMenuCategoryItemsUseCase =
        GetRestaurantMenuCategoryItemsUseCase(
      restaurantMenuRepository: mockRestaurantMenuRepository,
    );
  });

  const params = GetRestaurantMenuCategoryItemsParams(
    restaurantId: '1',
    categoryId: '1',
    page: 1,
    limit: 1,
    query: '',
    sortBy: 'name',
  );

  const testMenu = MenuModel(
    id: '1',
    items: [],
    totalItemsCount: 0,
    loadedItemsCount: 0,
  );

  test('should get the restaurant menu category items', () async {
    // arrange
    when(
      mockRestaurantMenuRepository.getRestaurantMenuCategoryItems(
        restaurantId: params.restaurantId,
        categoryName: params.categoryId,
        page: params.page,
        limit: params.limit,
        query: '',
        sortBy: 'name',
      ),
    ).thenAnswer(
      (_) async => const Right(testMenu),
    );

    // act
    final result = await getRestaurantMenuCategoryItemsUseCase(params);
    // assert
    expect(
      result,
      const Right(testMenu),
    );
    verify(
      mockRestaurantMenuRepository.getRestaurantMenuCategoryItems(
        restaurantId: params.restaurantId,
        categoryName: params.categoryId,
        page: params.page,
        limit: params.limit,
        query: '',
        sortBy: 'name',
      ),
    );
    verifyNoMoreInteractions(mockRestaurantMenuRepository);
  });
}
