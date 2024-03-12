import 'package:equatable/equatable.dart';

import 'discover_restaurant_item_model.dart';
import 'menu.dart';
import 'restaurant_image.dart';
import 'restaurant_location.dart';
import 'restaurant_phone_number.dart';
import 'restaurant_tag.dart';

class DiscoverRestaurantResultModel extends Equatable {
  final String? id;
  final String? name;
  final String? openingHour;
  final String? closingHour;
  final bool? isOpen;
  final double? averagePrice;
  final double? averageRating;
  final int? numberOfReviews;
  final double? popularityIndex;
  final dynamic userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<RestaurantPhoneNumber>? restaurantPhoneNumbers;
  final Menu? menu;
  final List<RestaurantTag>? restaurantTags;
  final List<RestaurantImage>? restaurantImages;
  final List<dynamic>? restaurantVideos;
  final List<RestaurantLocation>? restaurantLocations;
  final double? distance;
  final String? walkingTime;
  final String? ridingTime;
  final List<DiscoverRestaurantItem>? items;
  final String currencyCode;

  const DiscoverRestaurantResultModel(
      {this.id,
      this.name,
      this.openingHour,
      this.closingHour,
      this.isOpen,
      this.averagePrice,
      this.averageRating,
      this.numberOfReviews,
      this.popularityIndex,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.restaurantPhoneNumbers,
      this.menu,
      this.restaurantTags,
      this.restaurantImages,
      this.restaurantVideos,
      this.restaurantLocations,
      this.distance,
      this.walkingTime,
      this.ridingTime,
      this.items,
      this.currencyCode = "ETB"});

  factory DiscoverRestaurantResultModel.fromJson(Map<String, dynamic> data) {
    return DiscoverRestaurantResultModel(
      id: data['id'] as String?,
      name: data['name'] as String?,
      openingHour: data['opening_hour'] as String?,
      closingHour: data['closing_hour'] as String?,
      isOpen: data['is_open'] as bool?,
      averagePrice: (data['average_price'] as num?)?.toDouble() ?? 0.0,
      averageRating: double.tryParse(data['average_rating'].toString()) ?? 0.0,
      numberOfReviews: data['number_of_reviews'] as int?,
      currencyCode: data['currency'] ?? "ETB",
      popularityIndex:
          double.tryParse(data['popularity_index'].toString()) ?? 0.0,
      userId: data['user_id'] as dynamic,
      createdAt: data['createdAt'] == null
          ? null
          : DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
      restaurantPhoneNumbers: (data['restaurant_phone_numbers']
              as List<dynamic>?)
          ?.map(
              (e) => RestaurantPhoneNumber.fromJson(e as Map<String, dynamic>))
          .toList(),
      menu: data['menu'] == null
          ? null
          : Menu.fromJson(data['menu'] as Map<String, dynamic>),
      restaurantTags: (data['restaurant_tags'] as List<dynamic>?)
          ?.map((e) => RestaurantTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      restaurantImages: (data['restaurant_images'] as List<dynamic>?)
          ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
          .toList()
        ?..add(
          const RestaurantImage(
              id: "imageId",
              url:
                  "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"),
        ),
      restaurantVideos: data['restaurant_videos'] as List<dynamic>? ?? [""],
      restaurantLocations: (data['restaurant_locations'] as List<dynamic>?)
          ?.map((e) => RestaurantLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance: (data['distance'] as num?)?.toDouble(),
      walkingTime: data['walking_time'] ?? "0",
      ridingTime: data['riding_time'] ?? "0",
      items: (data['items'] as List<dynamic>?)
          ?.map((e) =>
              DiscoverRestaurantItem.fromJson(e as Map<String, dynamic>, data))
          .toList(),
    );
  }

  DiscoverRestaurantResultModel copyWith({
    String? id,
    String? name,
    String? openingHour,
    String? closingHour,
    bool? isOpen,
    double? averagePrice,
    double? averageRating,
    int? numberOfReviews,
    double? popularityIndex,
    dynamic userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RestaurantPhoneNumber>? restaurantPhoneNumbers,
    Menu? menu,
    List<RestaurantTag>? restaurantTags,
    List<RestaurantImage>? restaurantImages,
    List<dynamic>? restaurantVideos,
    List<RestaurantLocation>? restaurantLocations,
    double? distance,
    String? walkingTime,
    String? ridingTime,
    List<DiscoverRestaurantItem>? items,
  }) {
    return DiscoverRestaurantResultModel(
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
      restaurantPhoneNumbers:
          restaurantPhoneNumbers ?? this.restaurantPhoneNumbers,
      menu: menu ?? this.menu,
      restaurantTags: restaurantTags ?? this.restaurantTags,
      restaurantImages: restaurantImages ?? this.restaurantImages,
      restaurantVideos: restaurantVideos ?? this.restaurantVideos,
      restaurantLocations: restaurantLocations ?? this.restaurantLocations,
      distance: distance ?? this.distance,
      walkingTime: walkingTime ?? this.walkingTime,
      ridingTime: ridingTime ?? this.ridingTime,
      items: items ?? this.items,
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
      restaurantPhoneNumbers,
      menu,
      restaurantTags,
      restaurantImages,
      restaurantVideos,
      restaurantLocations,
      distance,
      walkingTime,
      ridingTime,
      items,
    ];
  }
}
