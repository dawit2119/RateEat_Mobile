import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

abstract class SearchPageRepository {
  Future<Either<Failure, List<RestaurantResult>>> searchRestaurants(
    String query,
  );
}
