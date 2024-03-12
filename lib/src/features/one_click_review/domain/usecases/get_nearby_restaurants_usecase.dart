import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/repositories/nearby_places_repository.dart';

class GetNearByRestaurantsUseCase extends UseCase<
    List<NearByRestaurantResponse>, GetNearByRestaurantsParams> {
  final NearByPlacesRepository repository;

  GetNearByRestaurantsUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<NearByRestaurantResponse>>> call(
      GetNearByRestaurantsParams params) async {
    return await repository.getNearByRestaurants(
      nearByRestaurantRequestModel: params.nearByRestaurantRequestModel,
    );
  }
}

class GetNearByRestaurantsParams extends Equatable {
  final NearByRestaurantRequestModel nearByRestaurantRequestModel;

  const GetNearByRestaurantsParams(
      {required this.nearByRestaurantRequestModel});

  @override
  List<Object?> get props => [];
}
