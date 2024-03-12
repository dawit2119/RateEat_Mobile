import 'dart:convert';

import 'package:rateeat_mobile/src/features/map_section/domain/domain.dart';

class RestaurantLocationModel extends RestaurantLocation {
  const RestaurantLocationModel({
    super.id,
    super.latitude,
    super.longitude,
    super.description,
  });

  factory RestaurantLocationModel.fromMap(Map<String, dynamic> data) {
    return RestaurantLocationModel(
      id: data['id'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      description: data['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RestaurantLocation].
  factory RestaurantLocationModel.fromJson(String data) {
    return RestaurantLocationModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RestaurantLocation] to a JSON string.
  String toJson() => json.encode(toMap());

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
