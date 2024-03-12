import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../filter_restaurants.dart';

class FilterRestaurantUseCase
    extends UseCase<List<dynamic>, FilterRestaurantParams> {
  FilterRepository repository;
  FilterRestaurantUseCase({required this.repository});

  @override
  Future<Either<Failure, List<dynamic>>> call(
      FilterRestaurantParams params) async {
    return await repository.filterRestaurant(params.query);
  }
}

class FilterRestaurantParams extends Equatable {
  final String query;

  const FilterRestaurantParams({
    required this.query,
  });

  @override
  List<Object> get props => [query];
}
