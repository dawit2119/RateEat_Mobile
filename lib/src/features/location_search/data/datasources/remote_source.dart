import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/location_coordinate_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/search_autocomplete_model.dart';

abstract class SearchLocationRemoteSource {
  Future<List<SearchAutoCompleteModel>> getLocations({required String place});
  Future<List<GoogleAutoCompleteModel>> getPlaces({required String place});
  Future<LocationCoordinateModel> getPlaceCoordinates(
      {required String placeId});
  Future<String> getLocationDescription(
      {required double latitude, required double longitude});
}

class SearchLocationRemoteSourceImpl implements SearchLocationRemoteSource {
  final Dio dio;

  SearchLocationRemoteSourceImpl({required this.dio});
  @override
  Future<List<SearchAutoCompleteModel>> getLocations(
      {required String place}) async {
    try {
      final response = await dio.get(
        "https://nominatim.openstreetmap.org/search?q=$place&countrycodes=ET,RW&format=json",
      );
      if (response.statusCode == 200) {
        final json = response.data;
        // final predictions = json['predictions'] as List;
        return json
            .map<SearchAutoCompleteModel>(
                (location) => SearchAutoCompleteModel.fromJson(location))
            .toList();
      } else {
        throw ServerException(errorMessage: 'Failed to load locations');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<GoogleAutoCompleteModel>> getPlaces(
      {required String place}) async {
    try {
      final et = await dio.get(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$place&types=establishment%7Cgeocode&components=country:ET&key=$googleApiKey");
      final rw = await dio.get(
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$place&types=establishment%7Cgeocode&components=country:RW&key=$googleApiKey");
      final predictions = [
        ...et.data['predictions'],
        ...rw.data['predictions'],
      ];
      return predictions
          .map<GoogleAutoCompleteModel>(
              (location) => GoogleAutoCompleteModel.fromJson(location))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<LocationCoordinateModel> getPlaceCoordinates(
      {required String placeId}) async {
    try {
      final response = await dio.get(
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey&fields=geometry%2cname");

      if (response.statusCode == 200) {
        final json = response.data;
        // final location = json['result']['geometry']['location'];
        // final double latitude = location['lat'];
        // final double longitude = location['lng'];
        return LocationCoordinateModel.fromJson(json['result']);
      } else {
        throw ServerException(errorMessage: 'Failed to get place coordinates');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<String> getLocationDescription({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        "https://maps.googleapis.com/maps/api/geocode/json",
        queryParameters: {
          "latlng": "$latitude,$longitude",
          "key": googleApiKey,
        },
      );

      if (response.statusCode == 200) {
        final json = response.data;
        final results = json['results'] as List<dynamic>?;

        if (results != null && results.isNotEmpty) {
          String? subArea;
          String? city;
          String? country;

          for (final result in results) {
            final components = result['address_components'] as List<dynamic>;

            for (final comp in components) {
              final types = comp['types'] as List<dynamic>;

              if (types.contains("administrative_area_level_4")) {
                subArea = comp['long_name']; // Example: Abado Ena Tafou 20/21
              } else if (types.contains("locality") ||
                  types.contains("administrative_area_level_2")) {
                city = comp['long_name']; // Example: Addis Ababa
              } else if (types.contains("country")) {
                country = comp['long_name']; // Example: Ethiopia
              }
            }
          }

          // Build final address
          final parts = [subArea, city, country]
              .where((e) => e != null && e.isNotEmpty)
              .toList();
          if (parts.isNotEmpty) {
            return parts.join(", ");
          }
        }

        throw ServerException(errorMessage: 'No readable address found');
      } else {
        throw ServerException(
          errorMessage: 'Failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(errorMessage: 'Error while fetching address: $e');
    }
  }
}
