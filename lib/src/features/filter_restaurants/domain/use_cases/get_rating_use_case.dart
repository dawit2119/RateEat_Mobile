import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';

import '../../filter_restaurants.dart';

class GetRatingUseCase extends UseCase<String, GetRatingParams> {
  FilterRepository repository;
  GetRatingUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(GetRatingParams params) async {
    return await repository.ratingQuery(params.rating, params.location);
  }
}

class GetRatingParams extends Equatable {
  final String rating;
  final String location;

  const GetRatingParams({
    required this.rating,
    required this.location,
  });

  @override
  List<Object> get props => [rating, location];
}
