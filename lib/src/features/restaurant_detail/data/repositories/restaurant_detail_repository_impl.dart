import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/remote_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/repositories/restaurant__detail_repository.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu_item.dart';

class RestaurantRepositoryImpl implements RestaurantDetailRepository {
  final RestaurantDetailDataSource restaurantDataProvider;
  RestaurantRepositoryImpl({required this.restaurantDataProvider});
  @override
  Future<Either<Failure, RestaurantModel>> getRestaurantDetail(
      String restaurantId, double? longitude, double? latitude) async {
    try {
      final restaurant = await restaurantDataProvider.getRestaurantDetail(
          restaurantId: restaurantId, longitude: longitude, latitude: latitude);
      return Right(restaurant);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getRestaurantItems(
      {required int limit,
      required int page,
      required String restaurantId}) async {
    try {
      final items = await restaurantDataProvider.getRestaurantItems(
          limit: limit, page: page, restaurantId: restaurantId);
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<RestaurantMenuItem>>> getPopularItems(
      {required String restaurantId}) async {
    try {
      final items = await restaurantDataProvider.getPopularItems(
          restaurantId: restaurantId);
      return Right(items);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PopularRestaurantReviewsResponseModel>>
      getPopularRestaurantReviews({required String restaurantId}) async {
    try {
      final popularReviews = await restaurantDataProvider
          .getPopularRestaurantReviews(restaurantId: restaurantId);
      return Right(popularReviews);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
