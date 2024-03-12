import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/location_coordinate_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/search_autocomplete_model.dart';

abstract class SearchLocationRepository {
  Future<Either<Failure, List<SearchAutoCompleteModel>>> getLocations({
    required String place,
  });
  Future<Either<Failure, List<GoogleAutoCompleteModel>>> getPlaces({
    required String place,
  });
  Future<Either<Failure, LocationCoordinateModel>> getPlaceCoordinates({
    required String placeId,
  });

  Future<Either<Failure, String>> getLocationDescription({
    required double latitude,
    required double longitude,
  });
}
