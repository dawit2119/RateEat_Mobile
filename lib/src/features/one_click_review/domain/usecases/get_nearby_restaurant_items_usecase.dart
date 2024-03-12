import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/repositories/nearby_places_repository.dart';

class GetNearByRestaurantItemsUseCase
    extends UseCase<List<NearByItemResponse>, GetNearByRestaurantItemsParams> {
  final NearByPlacesRepository repository;

  GetNearByRestaurantItemsUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<NearByItemResponse>>> call(
      GetNearByRestaurantItemsParams params) async {
    return await repository.getNearByRestaurantItems(
      nearByItemRequestModel: params.nearByItemRequestModel,
    );
  }
}

class GetNearByRestaurantItemsParams extends Equatable {
  final NearByItemRequestModel nearByItemRequestModel;

  const GetNearByRestaurantItemsParams({required this.nearByItemRequestModel});

  @override
  List<Object?> get props => [];
}
