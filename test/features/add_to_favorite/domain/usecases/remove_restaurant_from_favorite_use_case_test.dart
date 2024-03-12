import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/use_cases.dart';

import 'add_item_to_favorite_use_case_test.mocks.dart';

void main() {
  late MockFavoriteRepository mockFavoriteRepository;
  late RemoveRestaurantFromFavoriteUseCase removeRestaurantFromFavoriteUseCase;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    removeRestaurantFromFavoriteUseCase =
        RemoveRestaurantFromFavoriteUseCase(repository: mockFavoriteRepository);
  });

  const String restaurantId = '456';
  const params = RestaurantFavoriteParams(restaurantId: restaurantId);

  group('RemoveRestaurantFromFavoriteUseCase', () {
    test('should return true when the repository returns true', () async {
      when(mockFavoriteRepository.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => const Right(true));

      final result = await removeRestaurantFromFavoriteUseCase(params);

      expect(result, const Right(true));
      verify(mockFavoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test(
        'should return UnauthorizedRequestFailure when the repository returns UnauthorizedRequestFailure',
        () async {
      when(mockFavoriteRepository.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => Left(UnauthorizedRequestFailure()));

      final result = await removeRestaurantFromFavoriteUseCase(params);

      expect(result, Left(UnauthorizedRequestFailure()));
      verify(mockFavoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test(
        'should return ServerFailure when the repository returns server failure',
        () async {
      when(mockFavoriteRepository.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Error')));

      final result = await removeRestaurantFromFavoriteUseCase(params);

      expect(result, Left(ServerFailure(errorMessage: 'Error')));
      verify(mockFavoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test('should return CacheFailure when the repository returns cache failure',
        () async {
      when(mockFavoriteRepository.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => Left(CacheFailure()));

      final result = await removeRestaurantFromFavoriteUseCase(params);

      expect(result, Left(CacheFailure()));
      verify(mockFavoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });
  });
}
