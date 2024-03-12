import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';

abstract class RestaurantReviewRepository {
  Future<Either<Failure, RestaurantReviewsResponse>> getRestaurantReviewsByTime(
      {required restaurantId, required int limit, required int page});
  Future<Either<Failure, RestaurantReviewsResponse>>
      getRestaurantReviewsByPopularity(
          {required restaurantId, required int limit, required int page});
  Future<Either<Failure, String>> addRestaurantReview(
      {required AddRestaurantReviewRequestModel
          addRestaurantReviewRequestModel});
  Future<Either<Failure, String>> editRestaurantReview(
      {required EditRestaurantReviewRequestModel
          editRestaurantReviewRequestModel});
  Future<Either<Failure, String>> deleteRestaurantReview(
      {required DeleteRestaurantReviewRequestModel
          deleteRestaurantReviewRequestModel});
}
