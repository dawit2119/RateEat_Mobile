import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/data/datasources/remote_favorite_datasource.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  final RemoteFavoriteSource remoteSource;
  FavoriteRepositoryImpl({
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, bool>> addItemToFavorite(
      {required String itemId}) async {
    try {
      final added = await remoteSource.addItemToFavorite(
        itemId: itemId,
      );

      return Right(added);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(errorMessage: "unknown error"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeItemFromFavorite(
      {required String itemId}) async {
    try {
      final removed = await remoteSource.removeItemFromFavorite(
        itemId: itemId,
      );

      return Right(removed);
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(errorMessage: "unknown error"));
    }
  }

  @override
  Future<Either<Failure, bool>> addRestaurantToFavorite({
    required String restaurantId,
  }) async {
    try {
      final added = await remoteSource.addRestaurantToFavorite(
          restaurantId: restaurantId);

      return Right(added);
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(errorMessage: "unknown error"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeRestaurantFromFavorite({
    required String restaurantId,
  }) async {
    try {
      final removed = await remoteSource.removeRestaurantFromFavorite(
          restaurantId: restaurantId);

      return Right(removed);
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure(errorMessage: "unknown error"));
    }
  }
}
