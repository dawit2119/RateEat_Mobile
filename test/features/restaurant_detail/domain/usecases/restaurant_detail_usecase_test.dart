import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/repositories/restaurant__detail_repository.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/restaurant_detail_usecase.dart';

import 'restaurant_detail_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RestaurantDetailRepository>(),
])
void main() {
  late RestaurantDetailUseCase restaurantDetailUseCase;
  late MockRestaurantDetailRepository mockRestaurantDetailRepository;

  setUp(() {
    mockRestaurantDetailRepository = MockRestaurantDetailRepository();
    restaurantDetailUseCase = RestaurantDetailUseCase(
        restaurantRepository: mockRestaurantDetailRepository);
  });

  const testRestaurantId = "restaurantId";
  const testRestaurantModel = RestaurantModel(
    id: "restaurantId",
    name: "restaurantName",
    numberOfReviews: 0,
  );
  group('Get Restaurant Detail UseCase', () {
    test('should call the repository that gets restaurant detail', () async {
      // Arrange
      when(
        mockRestaurantDetailRepository.getRestaurantDetail(
            testRestaurantId, null, null),
      ).thenAnswer((_) async => const Right(testRestaurantModel));
      // Act
      final result = await restaurantDetailUseCase(
          const GetRestaurantDetailParams(restaurantId: testRestaurantId));

      // Assert
      expect(result, const Right(testRestaurantModel));
      verify(
        mockRestaurantDetailRepository.getRestaurantDetail(
            testRestaurantId, null, null),
      );
      verifyNoMoreInteractions(mockRestaurantDetailRepository);
    });
  });
}
