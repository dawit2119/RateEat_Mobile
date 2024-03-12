import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../discover_item/data/models/search_result.dart';
import '../repository/live_search_repo.dart';

class LiveSearchRestaurantsUseCase
    extends UseCase<List<RestaurantResult>, String> {
  final LiveSearchRepository liveSearchRepository;

  LiveSearchRestaurantsUseCase({required this.liveSearchRepository});

  @override
  Future<Either<Failure, List<RestaurantResult>>> call(String params) async {
    return await liveSearchRepository.searchRestaurants(params);
  }
}
