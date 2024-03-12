import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'filter_restaurant_usecase_test.mocks.dart';

void main() {
  late GetRatingUseCase getRatingUseCase;
  late MockFilterRepository mockFilterRepository;

  setUp(() {
    mockFilterRepository = MockFilterRepository();
    getRatingUseCase = GetRatingUseCase(repository: mockFilterRepository);
  });

  const testRating = 'testRating';
  const testLocation = 'testLocation';
  const params = GetRatingParams(
    rating: testRating,
    location: testLocation,
  );

  group('GetRatingUseCase', () {
    test('should call the repository that gets rating', () async {
      // Arrange
      when(
        mockFilterRepository.ratingQuery(
          testRating,
          testLocation,
        ),
      ).thenAnswer((_) async => const Right(testRating));
      // Act
      final result = await getRatingUseCase(
        params,
      );

      // Assert
      expect(result, const Right(testRating));
      verify(
        mockFilterRepository.ratingQuery(
          testRating,
          testLocation,
        ),
      );
      verifyNoMoreInteractions(mockFilterRepository);
    });
  });
}
