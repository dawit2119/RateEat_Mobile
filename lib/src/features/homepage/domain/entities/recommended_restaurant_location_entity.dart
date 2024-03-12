import 'package:equatable/equatable.dart';

class RecommendedRestaurantLocationEntity extends Equatable {
  final String? id;
  final double? latitude;
  final double? longitude;
  final String? description;

  const RecommendedRestaurantLocationEntity({
    this.id,
    this.latitude,
    this.longitude,
    this.description,
  });

  @override
  List<Object?> get props => [id, latitude, longitude, description];
}
