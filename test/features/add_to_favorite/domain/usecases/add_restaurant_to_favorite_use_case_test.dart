import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/add_restaurant_to_favorite_use_case.dart';

import 'add_item_to_favorite_use_case_test.mocks.dart';

void main() {
  late MockFavoriteRepository mockFavoriteRepository;
  late AddRestaurantToFavoriteUseCase addRestaurantToFavoriteUseCase;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    addRestaurantToFavoriteUseCase =
        AddRestaurantToFavoriteUseCase(repository: mockFavoriteRepository);
  });

  const String restaurantId = '456';
  const params = RestaurantFavoriteParams(restaurantId: restaurantId);

  group('AddRestaurantToFavoriteUseCase', () {
    test('should return true when the repository returns true', () async {
      when(mockFavoriteRepository.addRestaurantToFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => const Right(true));

      final result = await addRestaurantToFavoriteUseCase(params);

      expect(result, const Right(true));
      verify(mockFavoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test(
        'should return ServerFailure when the repository returns server failure',
        () async {
      when(mockFavoriteRepository.addRestaurantToFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Error')));

      final result = await addRestaurantToFavoriteUseCase(params);

      expect(result, Left(ServerFailure(errorMessage: 'Error')));
      verify(mockFavoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test('should return CacheFailure when the repository returns cache failure',
        () async {
      when(mockFavoriteRepository.addRestaurantToFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => Left(CacheFailure(errorMessage: "Error")));

      final result = await addRestaurantToFavoriteUseCase(params);

      expect(result, Left(CacheFailure(errorMessage: "Error")));
      verify(mockFavoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });
  });
}
