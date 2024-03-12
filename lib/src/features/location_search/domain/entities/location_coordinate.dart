import 'package:equatable/equatable.dart';

class LocationCoordinate extends Equatable {
  final String? name;
  final double latitude;
  final double longitude;

  const LocationCoordinate({
    required this.latitude,
    required this.longitude,
    this.name,
  });

  @override
  List<Object?> get props => [latitude, longitude, name];

  LocationCoordinate copyWith({
    String? description,
    String? placeId,
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return LocationCoordinate(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
