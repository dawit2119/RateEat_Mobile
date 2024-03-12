import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';

class RecommendedRestaurantEntity extends Equatable {
  final String? id;
  final String? name;
  final String? openingHour;
  final String? closingHour;
  final bool? isOpen;
  final double? averagePrice;
  final double? averageRating;
  final int? numberOfReviews;
  final int? popularityIndex;
  final String distance;
  final String walkingTime;
  final String ridingTime;
  final dynamic userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<RecommendedRestaurantTagModel>? restaurantTags;
  final List<dynamic>? restaurantImages;
  final List<dynamic>? restaurantVideos;
  final List<RecommendedRestaurantLocationModel>? restaurantLocations;
  final List<dynamic>? restaurantReviews;
  final List<dynamic>? restaurantPhoneNumbers;
  final bool doShowAvailabilityAlert;
  final String currencyCode;
  final bool restaurantOrderServiceAvailable;
  final bool restaurantOrderServiceOnline;
  const RecommendedRestaurantEntity({
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
    this.restaurantReviews,
    this.restaurantPhoneNumbers,
    this.distance = "",
    this.walkingTime = "",
    this.ridingTime = "",
    this.doShowAvailabilityAlert = false,
    this.currencyCode = "ETB",
    this.restaurantOrderServiceAvailable = false,
    this.restaurantOrderServiceOnline = false,
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
        restaurantReviews,
        restaurantPhoneNumbers,
        doShowAvailabilityAlert,
        currencyCode
      ];
}
