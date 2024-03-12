import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';

abstract class NearByPlacesRepository {
  Future<Either<Failure, List<NearByRestaurantResponse>>> getNearByRestaurants(
      {required NearByRestaurantRequestModel nearByRestaurantRequestModel});

  Future<Either<Failure, List<NearByItemResponse>>> getNearByRestaurantItems(
      {required NearByItemRequestModel nearByItemRequestModel});

  Future<Either<Failure, String>> addReviewToDraft(
      {required DraftReviewRequestModel draftReviewRequestModel});
}
