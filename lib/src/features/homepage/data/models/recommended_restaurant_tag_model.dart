import 'package:rateeat_mobile/src/features/homepage/homepage.dart';

class RecommendedRestaurantTagModel extends RecommendedRestaurantTagEntity {
  const RecommendedRestaurantTagModel({super.id, super.name});

  factory RecommendedRestaurantTagModel.fromJson(Map<String, dynamic> data) =>
      RecommendedRestaurantTagModel(
        id: data['id'] as String? ?? "",
        name: data['name'] as String? ?? "",
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
