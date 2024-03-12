import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';

class HomeRepositoryImpl extends HomeRepository {
  final RemoteHomeSource remoteSource;

  HomeRepositoryImpl({
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, PopularItemsResponse>> getTopRatedItems({
    required int limit,
    required int page,
    required List<String> tags,
    double? lat,
    double? lng,
    bool? isFasting,
  }) async {
    try {
      final popularItemsResponse = await remoteSource.getTopRatedItems(
        limit: limit,
        page: page,
        lat: lat,
        lng: lng,
        tags: tags,
        isFasting: isFasting,
      );

      return Right(popularItemsResponse);
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, List<PromotionModel>>> getPromotions() async {
    try {
      final promotions = await remoteSource.getPromotions();
      return Right(promotions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<RecommendedRestaurantModel>>>
      getRestaurantRecommendations({
    required int limit,
    required int page,
    double? latitude,
    double? longitude,
    required List<String> tags,
  }) async {
    try {
      final recommendations = await remoteSource.getRestaurantRecommendations(
        limit: limit,
        page: page,
        latitude: latitude,
        longitude: longitude,
        tags: tags,
      );
      return Right(recommendations);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
