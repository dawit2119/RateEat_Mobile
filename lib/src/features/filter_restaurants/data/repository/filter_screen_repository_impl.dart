import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';

import '../../filter_restaurants.dart';

class FilterRepositoryImpl implements FilterRepository {
  final FilterDataProvider filterDataProvider;

  FilterRepositoryImpl({
    required this.filterDataProvider,
  });

  @override
  Future<Either<Failure, List>> filterRestaurant(String query) async {
    try {
      return Right(
        await filterDataProvider.filterRestaurant(query),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> priceQuery(
      String price, String location) async {
    try {
      return Right(
        await filterDataProvider.priceQuery(price, location),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> priceRangeQuery(
      String priceRange, String location) async {
    try {
      return Right(
        await filterDataProvider.priceRangeQuery(priceRange, location),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> ratingQuery(
      String rating, String location) async {
    try {
      return Right(
        await filterDataProvider.ratingQuery(rating, location),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
