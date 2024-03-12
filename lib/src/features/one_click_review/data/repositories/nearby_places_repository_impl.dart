import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/datasources/nearby_places_datasource.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/repositories/nearby_places_repository.dart';

class NearByPlacesRepositoryImpl extends NearByPlacesRepository {
  final NearbyPlacesDataSource nearbyPlacesDataSource;
  NearByPlacesRepositoryImpl({required this.nearbyPlacesDataSource});

  @override
  Future<Either<Failure, List<NearByRestaurantResponse>>> getNearByRestaurants(
      {required NearByRestaurantRequestModel
          nearByRestaurantRequestModel}) async {
    try {
      final response = await nearbyPlacesDataSource.getNearByRestaurants(
          nearByRestaurantRequestModel: nearByRestaurantRequestModel);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NearByItemResponse>>> getNearByRestaurantItems(
      {required NearByItemRequestModel nearByItemRequestModel}) async {
    try {
      final response = await nearbyPlacesDataSource.getNearByRestaurantItems(
          nearByItemRequestModel: nearByItemRequestModel);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addReviewToDraft(
      {required DraftReviewRequestModel draftReviewRequestModel}) async {
    try {
      final response = await nearbyPlacesDataSource.addReviewToDraft(
          draftReviewRequestModel: draftReviewRequestModel);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
