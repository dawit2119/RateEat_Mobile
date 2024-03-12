import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_restaurant_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';

class RestaurantReviewRepositoryImpl extends RestaurantReviewRepository {
  final RestaurantReviewDataSource restaurantReviewSource;
  RestaurantReviewRepositoryImpl({required this.restaurantReviewSource});

  @override
  Future<Either<Failure, String>> addRestaurantReview(
      {required AddRestaurantReviewRequestModel
          addRestaurantReviewRequestModel}) async {
    try {
      final response = await restaurantReviewSource.addRestaurantReview(
          addRestaurantReviewRequestModel: addRestaurantReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> editRestaurantReview(
      {required EditRestaurantReviewRequestModel
          editRestaurantReviewRequestModel}) async {
    try {
      final response = await restaurantReviewSource.editRestaurantReview(
          editRestaurantReviewRequestModel: editRestaurantReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteRestaurantReview(
      {required DeleteRestaurantReviewRequestModel
          deleteRestaurantReviewRequestModel}) async {
    try {
      final response = await restaurantReviewSource.deleteRestaurantReview(
          deleteRestaurantReviewRequestModel:
              deleteRestaurantReviewRequestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantReviewsResponse>> getRestaurantReviewsByTime(
      {required restaurantId, required int limit, required int page}) async {
    try {
      final restaurantReviews =
          await restaurantReviewSource.getAllRestaurantReviewsByTime(
              restaurantId: restaurantId, limit: limit, page: page);
      return Right(restaurantReviews);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RestaurantReviewsResponse>>
      getRestaurantReviewsByPopularity(
          {required restaurantId,
          required int limit,
          required int page}) async {
    try {
      final restaurantReviews =
          await restaurantReviewSource.getAllRestaurantReviewsByPopularity(
              restaurantId: restaurantId, limit: limit, page: page);
      return Right(restaurantReviews);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
