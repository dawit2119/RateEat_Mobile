import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/search_location_usecase.dart';

class GoogleLocationUseCase
    extends UseCase<List<GoogleAutoCompleteModel>, SearchLocationParams> {
  final SearchLocationRepository repository;

  GoogleLocationUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GoogleAutoCompleteModel>>> call(
      SearchLocationParams params) async {
    return await repository.getPlaces(
      place: params.place,
    );
  }
}
