import 'package:rateeat_mobile/src/core/utils/map_tag_to_image.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_item_response.dart';

class SavedReviewItemResponseModel extends SavedReviewItemResponse {
  const SavedReviewItemResponseModel({
    required super.itemId,
    required super.itemName,
    super.price,
    super.restaurantName,
    super.imageUrl,
    super.itemImages,
    super.createdAt,
    super.categories,
  });

  factory SavedReviewItemResponseModel.fromJson(Map<String, dynamic> json) {
    return SavedReviewItemResponseModel(
      itemId: json['id'] ?? '',
      itemName: json['name'] ?? '',
      price: double.parse(json['price'].toDouble().toStringAsFixed(2)),
      imageUrl: (json['item_images'] != null && json['item_images'].isNotEmpty)
          ? json['item_images'][0]['url']
          : ImageMapping.getRestaurantImage(json),
      itemImages: json['item_images'] != null
          ? json['item_images'].map((item) => item["url"]).toList()
              as List<dynamic>?
          : [],
      restaurantName: json['categories'] != null
          ? json['categories']['menu']['restaurant']['name']
          : '',
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      categories: json['categories'] != null
          ? ItemCategoriesModel.fromJson(json["categories"])
          : null,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        itemName,
        price,
        restaurantName,
        imageUrl,
        itemImages,
        createdAt,
        categories,
      ];
}
