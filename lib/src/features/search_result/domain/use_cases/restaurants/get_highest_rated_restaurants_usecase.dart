import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/core/use_case/use_case.dart';
import 'package:rateeat_mobile/src/features/map_section/map_section.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/restaurant_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';

class GetHighestRatedRestaurantsUseCase
    extends UseCase<List<Restaurant>, FilterRestaurantResultsParams> {
  final RestaurantResultRepository restaurantResultRepository;

  GetHighestRatedRestaurantsUseCase({required this.restaurantResultRepository});

  @override
  Future<Either<Failure, List<Restaurant>>> call(params) async {
    return await restaurantResultRepository.getHighestRatedRestaurants(
        filterResultParams: params, page: params.page, limit: params.limit);
  }
}
