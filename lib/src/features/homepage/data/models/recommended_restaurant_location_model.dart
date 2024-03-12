import 'package:rateeat_mobile/src/features/homepage/homepage.dart';

class RecommendedRestaurantLocationModel
    extends RecommendedRestaurantLocationEntity {
  const RecommendedRestaurantLocationModel({
    super.id,
    super.latitude,
    super.longitude,
    super.description,
  });

  factory RecommendedRestaurantLocationModel.fromJson(
      Map<String, dynamic> data) {
    return RecommendedRestaurantLocationModel(
      id: data['id'] as String? ?? "",
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      description: data['description'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
      };
}
