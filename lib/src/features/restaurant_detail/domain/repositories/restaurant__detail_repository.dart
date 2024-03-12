import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

abstract class RestaurantDetailRepository {
  Future<Either<Failure, RestaurantModel>> getRestaurantDetail(
      String restaurantId, double? longitude, double? latitude);

  Future<Either<Failure, List<ItemModel>>> getRestaurantItems(
      {required int limit, required int page, required String restaurantId});

  Future<Either<Failure, List<RestaurantMenuItem>>> getPopularItems({
    required String restaurantId,
  });
  Future<Either<Failure, PopularRestaurantReviewsResponse>>
      getPopularRestaurantReviews({required String restaurantId});
}
