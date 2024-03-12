import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';

class GetRestaurantReviewsByPopularityUseCase extends UseCase<
    RestaurantReviewsResponse, GetPopularRestaurantReviewsParams> {
  final RestaurantReviewRepository repository;

  GetRestaurantReviewsByPopularityUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, RestaurantReviewsResponse>> call(
      GetPopularRestaurantReviewsParams params) async {
    return await repository.getRestaurantReviewsByPopularity(
      restaurantId: params.restaurantId,
      limit: params.limit,
      page: params.page,
    );
  }
}

class GetPopularRestaurantReviewsParams extends Equatable {
  final String restaurantId;
  final int page;
  final int limit;

  const GetPopularRestaurantReviewsParams({
    required this.restaurantId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [restaurantId, page, limit];
}
