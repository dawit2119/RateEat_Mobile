import 'dart:convert';

import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';

import '../../../features.dart';
import 'package:hive/hive.dart';

part 'restaurant_model.g.dart'; // The generated file

@HiveType(typeId: 25) // Unique typeId for RestaurantModel
class RestaurantModel extends Restaurant {
  const RestaurantModel({
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
    super.distance,
    super.walkingTime,
    super.ridingTime,
    super.restaurantTags,
    super.restaurantImages,
    super.restaurantVideos,
    super.restaurantLocations,
    super.restaurantPhoneNumbers,
    super.doShowAvailabilityAlert,
    super.currencyCode,
    super.restaurantOrderServiceAvailable,
    super.restaurantOrderServiceOnline,
    super.lastPriceUpdate,
    super.isFavorite,
  });

  factory RestaurantModel.fromEntity(Restaurant entity) => RestaurantModel(
        id: entity.id,
        name: entity.name,
        openingHour: entity.openingHour,
        closingHour: entity.closingHour,
        isOpen: entity.isOpen,
        averagePrice: entity.averagePrice,
        averageRating: entity.averageRating,
        numberOfReviews: entity.numberOfReviews,
        popularityIndex: entity.popularityIndex,
        userId: entity.userId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        distance: entity.distance,
        walkingTime: entity.walkingTime,
        ridingTime: entity.ridingTime,
        currencyCode: entity.currencyCode,
        restaurantTags: entity.restaurantTags,
        restaurantImages: entity.restaurantImages,
        restaurantVideos: entity.restaurantVideos,
        restaurantLocations: entity.restaurantLocations,
        restaurantPhoneNumbers: entity.restaurantPhoneNumbers,
        doShowAvailabilityAlert: entity.doShowAvailabilityAlert,
        restaurantOrderServiceAvailable: entity.restaurantOrderServiceAvailable,
        restaurantOrderServiceOnline: entity.restaurantOrderServiceOnline,
        lastPriceUpdate: entity.lastPriceUpdate,
        isFavorite: entity.isFavorite,
      );

  factory RestaurantModel.fromMap(Map<String, dynamic> data) {
    return RestaurantModel(
      id: data['id'] as String?,
      name: data['name'] as String?,
      openingHour: data['opening_hour'] as String?,
      closingHour: data['closing_hour'] as String?,
      isOpen: data['is_open'] as bool? ?? false,
      averagePrice: data['average_price']?.toDouble() ?? 0.0,
      averageRating: data['average_rating']?.toDouble() ?? 0.0,
      numberOfReviews: data['number_of_reviews'] as int? ?? 0,
      popularityIndex: data['popularity_index'] as int? ?? 0,
      userId: data['user_id'] as dynamic,
      distance: data['distance'] != null ? data['distance'].toString() : "10",
      walkingTime: data['walking_time']?.toString() ?? "",
      ridingTime: data['riding_time']?.toString() ?? "",
      currencyCode: data['currency']?.toString() ?? "ETB",
      createdAt: data['createdAt'] == null
          ? null
          : DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
      restaurantTags: (data['restaurant_tags'] as List<dynamic>?)
              ?.map(
                  (e) => RestaurantTagModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      restaurantImages: data['restaurant_images'] != null
          ? (data['restaurant_images'] as List)
              .map((image) =>
                  RestaurantMedia.fromJson(image as Map<String, dynamic>))
              .toList()
          : [],
      restaurantVideos: data['restaurant_videos'] != null
          ? (data['restaurant_videos'] as List)
              .map((video) =>
                  RestaurantMedia.fromJson(video as Map<String, dynamic>))
              .toList()
          : [],
      restaurantLocations: (data['restaurant_locations'] as List<dynamic>?)
              ?.map((e) =>
                  RestaurantLocationModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      restaurantPhoneNumbers: data['restaurant_phone_numbers'] != null
          ? (data['restaurant_phone_numbers'] as List)
              .map((e) =>
                  RestaurantPhoneNumber.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      doShowAvailabilityAlert:
          data['availability_alert'] != null ? true : false,
      restaurantOrderServiceAvailable:
          data["is_order_service_available"] ?? false,
      restaurantOrderServiceOnline: data["is_order_service_online"] ?? false,
      lastPriceUpdate: data["menu"]?["updatedAt"] != null
          ? DateTime.parse(data["menu"]?["updatedAt"] as String)
          : null,
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
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
        'restaurant_tags': restaurantTags
            ?.cast<RestaurantTagModel>()
            .map((e) => e.toMap())
            .toList(),
        'restaurant_images': restaurantImages,
        'restaurant_videos': restaurantVideos,
        'restaurant_locations': restaurantLocations
            ?.cast<RestaurantLocationModel>()
            .map((e) => e.toMap())
            .toList(),
        "restaurant_phone_numbers": restaurantPhoneNumbers,
      };

  factory RestaurantModel.fromJson(String data) {
    return RestaurantModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? openingHour,
    String? closingHour,
    String? distance,
    String? walkingTime,
    String? ridingTime,
    bool? isOpen,
    double? averagePrice,
    double? averageRating,
    int? numberOfReviews,
    int? popularityIndex,
    dynamic userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastPriceUpdate,
    List<RestaurantTagModel>? restaurantTags,
    List<RestaurantMedia>? restaurantImages,
    List<RestaurantMedia>? restaurantVideos,
    List<RestaurantLocationModel>? restaurantLocations,
    List<dynamic>? restaurantReviews,
    List<RestaurantPhoneNumber>? restaurantPhoneNumbers,
    bool? doShowAvailabilityAlert,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      openingHour: openingHour ?? this.openingHour,
      closingHour: closingHour ?? this.closingHour,
      isOpen: isOpen ?? this.isOpen,
      averagePrice: averagePrice ?? this.averagePrice,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      popularityIndex: popularityIndex ?? this.popularityIndex,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      restaurantTags: restaurantTags ?? this.restaurantTags,
      lastPriceUpdate: lastPriceUpdate ?? this.lastPriceUpdate,
      restaurantImages: restaurantImages ?? this.restaurantImages,
      restaurantVideos: restaurantVideos ?? this.restaurantVideos,
      restaurantLocations: restaurantLocations ?? this.restaurantLocations,
      restaurantPhoneNumbers:
          restaurantPhoneNumbers ?? this.restaurantPhoneNumbers,
      distance: distance ?? this.distance,
      ridingTime: ridingTime ?? this.ridingTime,
      walkingTime: walkingTime ?? this.walkingTime,
      doShowAvailabilityAlert:
          doShowAvailabilityAlert ?? this.doShowAvailabilityAlert,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      openingHour,
      closingHour,
      isOpen,
      averagePrice,
      averageRating,
      numberOfReviews,
      popularityIndex,
      userId,
      createdAt,
      updatedAt,
      restaurantTags,
      restaurantImages,
      restaurantVideos,
      restaurantLocations,
      restaurantPhoneNumbers,
      distance,
      walkingTime,
      ridingTime,
      doShowAvailabilityAlert,
      lastPriceUpdate,
    ];
  }
}
