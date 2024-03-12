import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';

class GetRestaurantRecommendationsUseCase extends UseCase<
    List<RecommendedRestaurantEntity>, GetRecommendedRestaurantsParams> {
  final HomeRepository repository;

  GetRestaurantRecommendationsUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<RecommendedRestaurantEntity>>> call(
      GetRecommendedRestaurantsParams params) async {
    return await repository.getRestaurantRecommendations(
      limit: params.limit,
      page: params.page,
      latitude: params.latitude,
      longitude: params.longitude,
      tags: params.tags,
    );
  }
}

class GetRecommendedRestaurantsParams extends Equatable {
  final int page;
  final int limit;
  final double? latitude;
  final double? longitude;
  final List<String> tags;

  const GetRecommendedRestaurantsParams({
    required this.page,
    required this.limit,
    required this.tags,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [page, limit, tags];
}
