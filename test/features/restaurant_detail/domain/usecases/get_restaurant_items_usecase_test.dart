import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_items_use_case.dart';
import 'restaurant_detail_usecase_test.mocks.dart';

void main() {
  late GetRestaurantItemsUseCase getRestaurantItemsUseCase;
  late MockRestaurantDetailRepository mockRestaurantDetailRepository;

  setUp(() {
    mockRestaurantDetailRepository = MockRestaurantDetailRepository();
    getRestaurantItemsUseCase = GetRestaurantItemsUseCase(
      repository: mockRestaurantDetailRepository,
    );
  });

  const testRestaurantId = "restaurantId";
  final testItemModel = [
    ItemModel(
      itemId: 'testItemId',
      itemName: 'testItemName',
      numberOfReviews: 0,
    )
  ];

  group('Get Popular Items UseCase', () {
    test('should call the repository that gets popular items', () async {
      // Arrange
      when(
        mockRestaurantDetailRepository.getRestaurantItems(
          limit: 10,
          page: 1,
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => Right(testItemModel));
      // Act
      final result = await getRestaurantItemsUseCase(
        const GetRestaurantItemsParams(
            restaurantId: testRestaurantId, limit: 10, page: 1),
      );
      // Assert
      expect(result, equals(Right(testItemModel)));
      verify(
        mockRestaurantDetailRepository.getRestaurantItems(
          limit: 10,
          page: 1,
          restaurantId: testRestaurantId,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantDetailRepository);
    });
  });
}
