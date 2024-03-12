import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/repositories/restaurant__detail_repository.dart';

class GetPopularRestaurantReviewsUseCase extends UseCase<
    PopularRestaurantReviewsResponse, GetRestaurantPopularReviewsParams> {
  final RestaurantDetailRepository repository;

  GetPopularRestaurantReviewsUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, PopularRestaurantReviewsResponse>> call(
      GetRestaurantPopularReviewsParams params) async {
    return await repository.getPopularRestaurantReviews(
        restaurantId: params.restaurantId);
  }
}

class GetRestaurantPopularReviewsParams extends Equatable {
  final String restaurantId;

  const GetRestaurantPopularReviewsParams({
    required this.restaurantId,
  });

  @override
  List<Object> get props => [restaurantId];
}
