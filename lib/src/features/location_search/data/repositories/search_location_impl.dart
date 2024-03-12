import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/location_search/data/datasources/remote_source.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/location_coordinate_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/search_autocomplete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/repositories/search_location_repository.dart';

class SearchLocationRepositoryImpl implements SearchLocationRepository {
  final SearchLocationRemoteSource remoteSource;

  SearchLocationRepositoryImpl({
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, List<SearchAutoCompleteModel>>> getLocations(
      {required String place}) async {
    try {
      final suggestions = await remoteSource.getLocations(place: place);
      return Right(suggestions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<GoogleAutoCompleteModel>>> getPlaces(
      {required String place}) async {
    try {
      final predictions = await remoteSource.getPlaces(place: place);
      return Right(predictions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LocationCoordinateModel>> getPlaceCoordinates(
      {required String placeId}) async {
    try {
      final predictions =
          await remoteSource.getPlaceCoordinates(placeId: placeId);
      return Right(predictions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getLocationDescription({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final locationDescription = await remoteSource.getLocationDescription(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(locationDescription);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
