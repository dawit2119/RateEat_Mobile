import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/data/repositories/favorite_repository_impl.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/data/datasources/remote_favorite_datasource.dart';

import 'favorite_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RemoteFavoriteSource>(),
])
void main() {
  late MockRemoteFavoriteSource mockRemoteSource;
  late FavoriteRepositoryImpl favoriteRepository;

  setUp(() {
    mockRemoteSource = MockRemoteFavoriteSource();
    favoriteRepository = FavoriteRepositoryImpl(
      remoteSource: mockRemoteSource,
    );
  });

  group('FavoriteRepositoryImpl', () {
    const String itemId = '123';
    const String restaurantId = '456';

    test('addItemToFavorite returns true on success', () async {
      when(mockRemoteSource.addItemToFavorite(itemId: itemId))
          .thenAnswer((_) async => true);

      final result = await favoriteRepository.addItemToFavorite(itemId: itemId);

      expect(result, const Right(true));
    });

    test('addItemToFavorite returns ServerFailure on ServerException',
        () async {
      when(mockRemoteSource.addItemToFavorite(itemId: itemId))
          .thenThrow(ServerException(errorMessage: 'Error'));

      final result = await favoriteRepository.addItemToFavorite(itemId: itemId);

      expect(result, Left(ServerFailure(errorMessage: 'Error')));
    });

    test('addItemToFavorite returns cache failure on cache exception',
        () async {
      when(mockRemoteSource.addItemToFavorite(itemId: itemId))
          .thenThrow(CacheException());

      final result = await favoriteRepository.addItemToFavorite(itemId: itemId);

      expect(result, Left(CacheFailure(errorMessage: 'Error')));
    });

    test('addItemToFavorite returns server failure on generic exception',
        () async {
      when(mockRemoteSource.addItemToFavorite(itemId: itemId))
          .thenThrow(Exception());

      final result = await favoriteRepository.addItemToFavorite(itemId: itemId);

      expect(result, Left(ServerFailure()));
    });

    test('removeItemFromFavorite returns true on success', () async {
      when(mockRemoteSource.removeItemFromFavorite(itemId: itemId))
          .thenAnswer((_) async => true);

      final result =
          await favoriteRepository.removeItemFromFavorite(itemId: itemId);

      expect(result, const Right(true));
    });

    test(
        'removeItemFromFavorite returns UnauthorizedRequestFailure on UnauthorizedRequestException',
        () async {
      when(mockRemoteSource.removeItemFromFavorite(itemId: itemId))
          .thenThrow(UnauthorizedRequestException());

      final result =
          await favoriteRepository.removeItemFromFavorite(itemId: itemId);

      expect(result, Left(UnauthorizedRequestFailure()));
    });

    test('removeItemFromFavorite returns server failure on server exception',
        () async {
      when(mockRemoteSource.removeItemFromFavorite(itemId: itemId))
          .thenThrow(ServerException());

      final result =
          await favoriteRepository.removeItemFromFavorite(itemId: itemId);

      expect(result, Left(ServerFailure()));
    });

    test('removeItemFromFavorite returns cache failure on cache exception',
        () async {
      when(mockRemoteSource.removeItemFromFavorite(itemId: itemId))
          .thenThrow(CacheException());

      final result =
          await favoriteRepository.removeItemFromFavorite(itemId: itemId);

      expect(result, Left(CacheFailure()));
    });

    test('removeItemFromFavorite returns server failure on generic exception',
        () async {
      when(mockRemoteSource.removeItemFromFavorite(itemId: itemId))
          .thenThrow(Exception());

      final result =
          await favoriteRepository.removeItemFromFavorite(itemId: itemId);

      expect(result, Left(ServerFailure()));
    });

    test('addRestaurantToFavorite returns true on success', () async {
      when(mockRemoteSource.addRestaurantToFavorite(restaurantId: restaurantId))
          .thenAnswer((_) async => true);

      final result = await favoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId);

      expect(result, const Right(true));
    });

    test('addRestaurantToFavorite returns ServerFailure on ServerException',
        () async {
      when(mockRemoteSource.addRestaurantToFavorite(restaurantId: restaurantId))
          .thenThrow(ServerException(errorMessage: 'Error'));

      final result = await favoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId);

      expect(result, Left(ServerFailure(errorMessage: 'Error')));
    });

    test(
        'addRestaurantToFavorite returns unauthorized failure on unauthorizedexception',
        () async {
      when(mockRemoteSource.addRestaurantToFavorite(restaurantId: restaurantId))
          .thenThrow(UnauthorizedRequestException());

      final result = await favoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId);

      expect(result, Left(UnauthorizedRequestFailure()));
    });

    test('addRestaurantToFavorite returns cache failure on cache exception',
        () async {
      when(mockRemoteSource.addRestaurantToFavorite(restaurantId: restaurantId))
          .thenThrow(CacheException());

      final result = await favoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId);

      expect(result, Left(CacheFailure()));
    });

    test('addRestaurantToFavorite returns server failure on generic exception',
        () async {
      when(mockRemoteSource.addRestaurantToFavorite(restaurantId: restaurantId))
          .thenThrow(Exception());

      final result = await favoriteRepository.addRestaurantToFavorite(
          restaurantId: restaurantId);

      expect(result, Left(ServerFailure()));
    });

    test('removeRestaurantFromFavorite returns true on success', () async {
      when(mockRemoteSource.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenAnswer((_) async => true);

      final result = await favoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      expect(result, const Right(true));
    });

    test(
        'removeRestaurantFromFavorite returns UnauthorizedRequestFailure on UnauthorizedRequestException',
        () async {
      when(mockRemoteSource.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenThrow(UnauthorizedRequestException());

      final result = await favoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      expect(result, Left(UnauthorizedRequestFailure()));
    });

    test(
        'removeRestaurantFromFavorite returns server failure on server exception',
        () async {
      when(mockRemoteSource.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenThrow(ServerException());

      final result = await favoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      expect(result, Left(ServerFailure()));
    });

    test(
        'removeRestaurantFromFavorite returns cache failure on cache exception',
        () async {
      when(mockRemoteSource.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenThrow(CacheException());

      final result = await favoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      expect(result, Left(CacheFailure()));
    });

    test(
        'removeRestaurantFromFavorite returns server failure on generic exception',
        () async {
      when(mockRemoteSource.removeRestaurantFromFavorite(
              restaurantId: restaurantId))
          .thenThrow(Exception());

      final result = await favoriteRepository.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      expect(result, Left(ServerFailure()));
    });
  });
}
