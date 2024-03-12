import 'package:rateeat_mobile/src/features/location_search/domain/entities/location_coordinate.dart';

class LocationCoordinateModel extends LocationCoordinate {
  const LocationCoordinateModel({
    required super.name,
    required super.latitude,
    required super.longitude,
  });

  factory LocationCoordinateModel.fromJson(Map<String, dynamic> json) {
    return LocationCoordinateModel(
      name: json['name'] ?? '',
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
    );
  }
}
