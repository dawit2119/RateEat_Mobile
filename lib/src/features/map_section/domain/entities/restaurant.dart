import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';
import '../../../features.dart';

part 'restaurant.g.dart';

@HiveType(typeId: 9)
class Restaurant extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? openingHour;

  @HiveField(3)
  final String? closingHour;

  @HiveField(4)
  final bool? isOpen;

  @HiveField(5)
  final double? averagePrice;

  @HiveField(6)
  final double? averageRating;

  @HiveField(7)
  final int? numberOfReviews;

  @HiveField(8)
  final int? popularityIndex;

  @HiveField(9)
  final String distance;

  @HiveField(10)
  final String walkingTime;

  @HiveField(11)
  final String ridingTime;

  @HiveField(12)
  final String? userId;

  @HiveField(13)
  final DateTime? createdAt;

  @HiveField(14)
  final DateTime? updatedAt;

  @HiveField(15)
  final List<RestaurantTag>? restaurantTags;

  @HiveField(16)
  final List<RestaurantMedia>? restaurantImages;

  @HiveField(17)
  final List<RestaurantMedia>? restaurantVideos;

  @HiveField(18)
  final List<RestaurantLocation>? restaurantLocations;

  @HiveField(19)
  final List<RestaurantPhoneNumber>? restaurantPhoneNumbers;

  @HiveField(20)
  final bool doShowAvailabilityAlert;

  @HiveField(21)
  final String currencyCode;

  @HiveField(22)
  final bool restaurantOrderServiceAvailable;

  @HiveField(23)
  final bool restaurantOrderServiceOnline;

  @HiveField(24)
  final DateTime? lastPriceUpdate;

  @HiveField(25)
  final bool? isFavorite;
  const Restaurant({
    this.id,
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
    this.restaurantTags,
    this.restaurantImages,
    this.restaurantVideos,
    this.restaurantLocations,
    this.restaurantPhoneNumbers,
    this.lastPriceUpdate,
    this.distance = "",
    this.walkingTime = "",
    this.ridingTime = "",
    this.doShowAvailabilityAlert = false,
    this.currencyCode = "ETB",
    this.restaurantOrderServiceAvailable = false,
    this.restaurantOrderServiceOnline = false,
    this.isFavorite,
  });

  @override
  List<Object?> get props => [
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
        doShowAvailabilityAlert,
        lastPriceUpdate,
        currencyCode,
        isFavorite
      ];
}

@HiveType(typeId: 11)
// In restaurant_model.dart (at the bottom) or separate file
@HiveType(typeId: 11)
class RestaurantMedia extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final bool isLeading;

  const RestaurantMedia({
    required this.id,
    required this.url,
    this.isLeading = false,
  });

  @override
  List<Object?> get props => [id, url, isLeading];

  factory RestaurantMedia.fromJson(Map<String, dynamic> json) =>
      RestaurantMedia(
        //FIX: Use ?.toString() and ?? "" to prevent crash if ID is null
        id: json["id"]?.toString() ?? "",
        url: json["url"] ?? "",
        isLeading: json["is_leading"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "is_leading": isLeading,
      };
}
