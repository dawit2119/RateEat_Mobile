import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'filter_restaurant_usecase_test.mocks.dart';

void main() {
  late GetPriceUseCase getPriceUseCase;
  late MockFilterRepository mockFilterRepository;

  setUp(() {
    mockFilterRepository = MockFilterRepository();
    getPriceUseCase = GetPriceUseCase(repository: mockFilterRepository);
  });

  const testPrice = 'testPrice';
  const testLocation = 'testLocation';
  const params = GetPriceParams(
    price: testPrice,
    location: testLocation,
  );

  group('GetPriceUseCase', () {
    test('should call the repository that gets price', () async {
      // Arrange
      when(
        mockFilterRepository.priceQuery(
          testPrice,
          testLocation,
        ),
      ).thenAnswer((_) async => const Right(testPrice));
      // Act
      final result = await getPriceUseCase(
        params,
      );

      // Assert
      expect(result, const Right(testPrice));
      verify(
        mockFilterRepository.priceQuery(
          testPrice,
          testLocation,
        ),
      );
      verifyNoMoreInteractions(mockFilterRepository);
    });
  });
}
