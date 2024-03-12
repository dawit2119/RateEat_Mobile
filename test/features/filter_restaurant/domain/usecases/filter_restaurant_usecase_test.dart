import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'filter_restaurant_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FilterRepository>(),
])
void main() {
  late FilterRestaurantUseCase filterRestaurantUseCase;
  late MockFilterRepository mockFilterRepository;

  setUp(() {
    mockFilterRepository = MockFilterRepository();
    filterRestaurantUseCase =
        FilterRestaurantUseCase(repository: mockFilterRepository);
  });

  const testQuery = 'testQuery';
  const params = FilterRestaurantParams(
    query: testQuery,
  );

  group('FilterRestaurantUseCase', () {
    test('should call the repository that filters restaurants', () async {
      // Arrange
      when(
        mockFilterRepository.filterRestaurant(
          testQuery,
        ),
      ).thenAnswer((_) async => const Right([]));
      // Act
      final result = await filterRestaurantUseCase(
        params,
      );

      // Assert
      expect(result, const Right([]));
      verify(
        mockFilterRepository.filterRestaurant(
          testQuery,
        ),
      );
      verifyNoMoreInteractions(mockFilterRepository);
    });
  });
}
