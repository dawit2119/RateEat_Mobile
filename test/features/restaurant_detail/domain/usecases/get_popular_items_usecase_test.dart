import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_popular_items_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

import 'restaurant_detail_usecase_test.mocks.dart';

void main() {
  late GetPopularItemsUseCase getPopularItemsUseCase;
  late MockRestaurantDetailRepository mockRestaurantDetailRepository;

  setUp(() {
    mockRestaurantDetailRepository = MockRestaurantDetailRepository();
    getPopularItemsUseCase = GetPopularItemsUseCase(
      repository: mockRestaurantDetailRepository,
    );
  });

  const testRestaurantId = "restaurantId";
  const testRestaurantMenuItem = [
    RestaurantMenuItem(
      id: "restaurantId",
      name: "restaurantName",
      price: 0,
      description: "description",
      imageUrl: "imageUrl",
    )
  ];

  group('Get Popular Items UseCase', () {
    test('should call the repository that gets popular items', () async {
      // Arrange
      when(
        mockRestaurantDetailRepository.getPopularItems(
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => const Right(testRestaurantMenuItem));
      // Act
      final result = await getPopularItemsUseCase(
        const GetPopularItemsParams(restaurantId: testRestaurantId),
      );
      // Assert
      expect(result, equals(const Right(testRestaurantMenuItem)));
      verify(
        mockRestaurantDetailRepository.getPopularItems(
          restaurantId: testRestaurantId,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantDetailRepository);
    });
  });
}
