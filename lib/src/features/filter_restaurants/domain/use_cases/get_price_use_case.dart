import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';

import '../../filter_restaurants.dart';

class GetPriceUseCase extends UseCase<String, GetPriceParams> {
  FilterRepository repository;
  GetPriceUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(GetPriceParams params) {
    return repository.priceQuery(params.price, params.location);
  }
}

class GetPriceParams extends Equatable {
  final String price;
  final String location;

  const GetPriceParams({
    required this.price,
    required this.location,
  });

  @override
  List<Object> get props => [price, location];
}
