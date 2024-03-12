import 'package:equatable/equatable.dart';

class RestaurantLocation extends Equatable {
  final String? id;
  final double? latitude;
  final double? longitude;
  final String? description;

  const RestaurantLocation({
    this.id,
    this.latitude,
    this.longitude,
    this.description,
  });

  factory RestaurantLocation.fromJson(Map<String, dynamic> data) {
    return RestaurantLocation(
      id: data['id'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      description: data['description'] as String?,
    );
  }

  RestaurantLocation copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? description,
  }) {
    return RestaurantLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, latitude, longitude, description];
}
