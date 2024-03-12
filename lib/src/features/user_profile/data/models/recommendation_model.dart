import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class UserRecommendationModel extends UserRecommendation {
  const UserRecommendationModel(
      {required super.item,
      required super.restaurant,
      required super.recommendationContent});

  factory UserRecommendationModel.fromMap(data) {
    return UserRecommendationModel(
        recommendationContent: data["message"] ?? "",
        item: data["recommended_item"] != null
            ? RecommendationItemModel.fromMap(data["recommended_item"])
            : null,
        restaurant: data['recommended_restaurant'] != null
            ? RecommendationRestaurantModel.fromMap(
                data['recommended_restaurant'])
            : null);
  }
}
