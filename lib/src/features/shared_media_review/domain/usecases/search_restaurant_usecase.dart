import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/restaurant_search_result.dart';
import '../repositories/get_restaurant_repository.dart';

class SearchRestaurantUseCase
    extends UseCase<List<RestaurantSearchResult>, String> {
  final GetRestaurantRepository getRestaurantRepository;

  SearchRestaurantUseCase({required this.getRestaurantRepository});

  @override
  Future<Either<Failure, List<RestaurantSearchResult>>> call(
      String params) async {
    return getRestaurantRepository.searchRestaurant(query: params);
  }
}
