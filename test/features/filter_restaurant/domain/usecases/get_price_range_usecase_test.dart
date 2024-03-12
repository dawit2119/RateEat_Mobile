import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'filter_restaurant_usecase_test.mocks.dart';

void main() {
  late GetPriceRangeUseCase getPriceRangeUseCase;
  late MockFilterRepository mockFilterRepository;

  setUp(() {
    mockFilterRepository = MockFilterRepository();
    getPriceRangeUseCase =
        GetPriceRangeUseCase(repository: mockFilterRepository);
  });

  const testPriceRange = 'testPriceRange';
  const testLocation = 'testLocation';
  const params = GetPriceRangeParams(
    priceRange: testPriceRange,
    location: testLocation,
  );

  group('GetPriceRangeUseCase', () {
    test('should call the repository that gets price range', () async {
      // Arrange
      when(
        mockFilterRepository.priceRangeQuery(
          testPriceRange,
          testLocation,
        ),
      ).thenAnswer((_) async => const Right(testPriceRange));
      // Act
      final result = await getPriceRangeUseCase(
        params,
      );

      // Assert
      expect(result, const Right(testPriceRange));
      verify(
        mockFilterRepository.priceRangeQuery(
          testPriceRange,
          testLocation,
        ),
      );
      verifyNoMoreInteractions(mockFilterRepository);
    });
  });
}
