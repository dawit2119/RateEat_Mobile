import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/search_autocomplete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/repositories/search_location_repository.dart';

class SearchLocationUseCase
    extends UseCase<List<SearchAutoCompleteModel>, SearchLocationParams> {
  final SearchLocationRepository repository;

  SearchLocationUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SearchAutoCompleteModel>>> call(
      SearchLocationParams params) async {
    return await repository.getLocations(
      place: params.place,
    );
  }
}

class SearchLocationParams extends Equatable {
  final String place;

  const SearchLocationParams({
    required this.place,
  });

  @override
  List<Object?> get props => [place];
}
