import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';

abstract class FilterRepository {
  Future<Either<Failure, String>> ratingQuery(String rating, String location);
  Future<Either<Failure, String>> priceQuery(String price, String location);
  Future<Either<Failure, String>> priceRangeQuery(
    String priceRange,
    String location,
  );
  Future<Either<Failure, List<dynamic>>> filterRestaurant(String query);
}
