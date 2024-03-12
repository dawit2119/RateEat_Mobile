import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';

class GetRestaurantReviewsByTimeUseCase extends UseCase<
    RestaurantReviewsResponse, GetRecentRestaurantReviewsParams> {
  final RestaurantReviewRepository repository;

  GetRestaurantReviewsByTimeUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, RestaurantReviewsResponse>> call(
      GetRecentRestaurantReviewsParams params) async {
    return await repository.getRestaurantReviewsByTime(
      restaurantId: params.restaurantId,
      limit: params.limit,
      page: params.page,
    );
  }
}

class GetRecentRestaurantReviewsParams extends Equatable {
  final String restaurantId;
  final int page;
  final int limit;

  const GetRecentRestaurantReviewsParams({
    required this.restaurantId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [restaurantId, page, limit];
}
