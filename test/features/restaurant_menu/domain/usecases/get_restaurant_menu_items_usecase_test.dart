import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/homepage/data/models/models.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_items_use_case.dart';

import 'add_candidate_item_usecase_test.mocks.dart';

void main() {
  late GetRestaurantMenuItemsUseCase getRestaurantMenuItemsUseCase;
  late MockRestaurantMenuRepository mockRestaurantMenuRepository;

  setUp(() {
    mockRestaurantMenuRepository = MockRestaurantMenuRepository();
    getRestaurantMenuItemsUseCase = GetRestaurantMenuItemsUseCase(
      restaurantMenuRepository: mockRestaurantMenuRepository,
    );
  });

  const params = GetRestaurantItemsParams(
    restaurantId: '1',
    page: 1,
    limit: 10,
  );

  final testResponse = [
    ItemModel(
      itemId: '1',
      itemName: 'name',
      description: 'description',
      price: 10.0,
      categoryId: '1',
      numberOfReviews: 0,
    ),
  ];

  test('should get the restaurant menu items', () async {
    // arrange
    when(
      mockRestaurantMenuRepository.getRestaurantMenuItems(
        restaurantId: params.restaurantId,
        page: params.page,
        limit: params.limit,
      ),
    ).thenAnswer(
      (_) async => Right(testResponse),
    );

    // act
    final result = await getRestaurantMenuItemsUseCase(params);
    // assert
    expect(
      result,
      Right(testResponse),
    );
    verify(
      mockRestaurantMenuRepository.getRestaurantMenuItems(
        restaurantId: params.restaurantId,
        page: params.page,
        limit: params.limit,
      ),
    );
    verifyNoMoreInteractions(mockRestaurantMenuRepository);
  });
}
