import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';

import '../../filter_restaurants.dart';

class GetPriceRangeUseCase extends UseCase<String, GetPriceRangeParams> {
  FilterRepository repository;
  GetPriceRangeUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(GetPriceRangeParams params) async {
    return await repository.priceRangeQuery(params.priceRange, params.location);
  }
}

class GetPriceRangeParams extends Equatable {
  final String priceRange;
  final String location;

  const GetPriceRangeParams({
    required this.priceRange,
    required this.location,
  });

  @override
  List<Object> get props => [priceRange, location];
}
