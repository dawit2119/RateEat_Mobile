import 'package:rateeat_mobile/src/features/homepage/homepage.dart';

class RecommendedRestaurantModel extends RecommendedRestaurantEntity {
  const RecommendedRestaurantModel({
    super.id,
    super.name,
    super.openingHour,
    super.closingHour,
    super.isOpen,
    super.averagePrice,
    super.averageRating,
    super.numberOfReviews,
    super.popularityIndex,
    super.userId,
    super.createdAt,
    super.updatedAt,
    String? distance,
    String? walkingTime,
    String? ridingTime,
    super.restaurantTags,
    super.restaurantImages,
    super.restaurantVideos,
    super.restaurantLocations,
    super.restaurantReviews,
    List<dynamic>? restaurantPhoneNumbers,
    super.doShowAvailabilityAlert,
    super.currencyCode,
    super.restaurantOrderServiceAvailable,
    super.restaurantOrderServiceOnline,
  }) : super(
          restaurantPhoneNumbers: restaurantPhoneNumbers ?? const [],
          distance: distance ?? "",
          walkingTime: walkingTime ?? "",
          ridingTime: ridingTime ?? "",
        );

  factory RecommendedRestaurantModel.fromJson(Map<String, dynamic> data) {
    return RecommendedRestaurantModel(
      id: data['id'] as String? ?? "",
      name: data['name'] as String? ?? "",
      openingHour: data['opening_hour'] as String?,
      closingHour: data['closing_hour'] as String?,
      isOpen: data['is_open'] as bool? ?? false,
      averagePrice: data['average_price']?.toDouble() ?? 0.0,
      averageRating: data['average_rating']?.toDouble() ?? 0.0,
      numberOfReviews: data['number_of_reviews'] as int? ?? 0,
      popularityIndex: data['popularity_index'] as int? ?? 0,
      userId: data['user_id'] as dynamic,
      distance: data['distance'] != null ? data['distance'].toString() : "",
      walkingTime: data['walking_time'] ?? "",
      ridingTime: data['riding_time'] ?? "",
      currencyCode: data['currency'] ?? "ETB",
      createdAt: data['createdAt'] == null
          ? null
          : DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
      restaurantTags: (data['restaurant_tags'] as List<dynamic>?)
              ?.map((e) => RecommendedRestaurantTagModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      restaurantImages: data['restaurant_images'] != null
          ? data['restaurant_images'].map((item) => item).toList()
              as List<dynamic>?
          : [],
      restaurantVideos: data['restaurant_videos'] != null
          ? data['restaurant_videos'].map((item) => item["url"]).toList()
              as List<dynamic>?
          : [],
      restaurantLocations: (data['restaurant_locations'] as List<dynamic>?)
              ?.map((e) => RecommendedRestaurantLocationModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      restaurantReviews: data['restaurant_reviews'] as List<dynamic>?,
      restaurantPhoneNumbers:
          data['restaurant_phone_numbers'] as List<dynamic>?,
      doShowAvailabilityAlert:
          data['availability_alert'] != null ? true : false,
      restaurantOrderServiceAvailable:
          data["is_order_service_available"] ?? false,
      restaurantOrderServiceOnline: data["is_order_service_online"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'opening_hour': openingHour,
        'closing_hour': closingHour,
        'is_open': isOpen,
        'average_price': averagePrice,
        'average_rating': averageRating,
        'number_of_reviews': numberOfReviews,
        'popularity_index': popularityIndex,
        'user_id': userId,
        'distance': distance,
        'walkingTime': walkingTime,
        'ridingTime': ridingTime,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'restaurant_tags': restaurantTags?.map((e) => e.toJson()).toList(),
        'restaurant_images': restaurantImages,
        'restaurant_videos': restaurantVideos,
        'restaurant_locations':
            restaurantLocations?.map((e) => e.toJson()).toList(),
        'restaurant_reviews': restaurantReviews,
        "restaurant_phone_numbers": restaurantPhoneNumbers,
      };
}
