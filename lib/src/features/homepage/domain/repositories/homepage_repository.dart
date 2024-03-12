import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';

abstract class HomeRepository {
  Future<Either<Failure, PopularItemsResponse>> getTopRatedItems({
    required int limit,
    required int page,
    required List<String> tags,
    double? lat,
    double? lng,
    bool? isFasting,
  });
  Future<Either<Failure, List<Promotion>>> getPromotions();
  Future<Either<Failure, List<RecommendedRestaurantEntity>>>
      getRestaurantRecommendations({
    required int limit,
    required int page,
    required List<String> tags,
    double? latitude,
    double? longitude,
  });
}
