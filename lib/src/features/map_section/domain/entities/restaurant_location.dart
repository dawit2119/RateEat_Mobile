import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'restaurant_location.g.dart';

@HiveType(typeId: 12)
class RestaurantLocation extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final double? latitude;

  @HiveField(2)
  final double? longitude;

  @HiveField(3)
  final String? description;

  const RestaurantLocation({
    this.id,
    this.latitude,
    this.longitude,
    this.description,
  });

  @override
  List<Object?> get props => [id, latitude, longitude, description];
}
