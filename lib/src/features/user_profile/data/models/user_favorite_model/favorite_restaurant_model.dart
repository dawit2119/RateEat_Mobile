import 'dart:convert';

import 'package:rateeat_mobile/src/core/utils/map_tag_to_image.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class FavoriteRestaurantModel extends FavoriteRestaurant {
  const FavoriteRestaurantModel(
      {super.id,
      super.name,
      super.averageRating,
      super.averagePrice,
      super.numberOfReviews,
      super.averageItemsRating,
      super.totalItemReviews,
      super.restaurantImages,
      super.imageUrl});

  factory FavoriteRestaurantModel.fromMap(Map<String, dynamic> data) {
    return FavoriteRestaurantModel(
      id: (data['id'] as String?) ?? "",
      name: (data['name'] as String?) ?? "",
      averageRating: double.parse(
        (data['average_rating']?.toDouble() ?? 0.0).toStringAsFixed(2),
      ),
      averagePrice:
          double.parse(data['average_price'].toDouble().toStringAsFixed(2)),
      numberOfReviews: (data['number_of_reviews'] as int?) ?? 0,
      averageItemsRating: double.parse(
        (data['items_average_rating']?.toDouble() ?? 0.0).toStringAsFixed(2),
      ),
      imageUrl: data['restaurant_images'] != null
          ? (data['restaurant_images'] as List<dynamic>).isNotEmpty
              ? (data['restaurant_images'] as List<dynamic>)[0]["url"]
              : ImageMapping.getRestaurantImage(data)
          : [],
      totalItemReviews: (data['total_item_reviews'] as int?),
      restaurantImages: data['restaurant_images'] != null
          ? data['restaurant_images'].map((item) => item["url"]).toList()
              as List<dynamic>?
          : [],
    );
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'average_rating': averageRating,
        'average_price': averagePrice,
        'number_of_reviews': numberOfReviews,
        'items_average_rating': averageItemsRating,
        'total_item_reviews': totalItemReviews,
        'restaurant_images': restaurantImages,
        'image_url': imageUrl,
      };

  factory FavoriteRestaurantModel.fromJson(String data) {
    return FavoriteRestaurantModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  FavoriteRestaurantModel copyWith({
    String? id,
    String? name,
    double? averageRating,
    double? averagePrice,
    int? numberOfReviews,
    double? averageItemsRating,
    int? totalItemReviews,
    List<dynamic>? restaurantImages,
    String? imageUrl,
  }) {
    return FavoriteRestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      averageRating: averageRating ?? this.averageRating,
      averagePrice: averagePrice ?? this.averagePrice,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      averageItemsRating: averageItemsRating ?? this.averageItemsRating,
      totalItemReviews: totalItemReviews ?? this.totalItemReviews,
      restaurantImages: restaurantImages ?? this.restaurantImages,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
