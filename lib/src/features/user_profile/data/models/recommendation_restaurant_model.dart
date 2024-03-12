import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class RecommendationRestaurantModel extends RecommendationRestaurant {
  const RecommendationRestaurantModel(
      {required super.name,
      required super.review,
      required super.id,
      required super.imageUrl});

  factory RecommendationRestaurantModel.fromMap(data) {
    return RecommendationRestaurantModel(
      id: data["id"] ?? "",
      name: data['name'] ?? "",
      imageUrl: data['image_url'] ??
          "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
      review: data['average_rating'] is double
          ? data['average_rating'] ?? 0.0
          : data['average_rating']?.toDouble() ?? 0.0,
    );
  }
}
