import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/repositories/restaurant__detail_repository.dart';

class RestaurantDetailUseCase
    extends UseCase<RestaurantModel, GetRestaurantDetailParams> {
  final RestaurantDetailRepository restaurantRepository;
  RestaurantDetailUseCase({required this.restaurantRepository});

  @override
  Future<Either<Failure, RestaurantModel>> call(params) async {
    return await restaurantRepository.getRestaurantDetail(
        params.restaurantId, params.longitude, params.latitude);
  }
}

class GetRestaurantDetailParams extends Equatable {
  final String restaurantId;
  final double? longitude;
  final double? latitude;

  const GetRestaurantDetailParams(
      {required this.restaurantId, this.longitude, this.latitude});

  @override
  List<Object> get props => [restaurantId];
}
