import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_review_response.dart';

part 'popular_restaurant_reviews_response.g.dart';

@HiveType(typeId: 46)
class PopularRestaurantReviewsResponse extends Equatable {
  @HiveField(0)
  final List<PopularRestaurantReviewResponse> reviews;
  @HiveField(1)
  final List<int> ratingsCount;
  @HiveField(2)
  final double averageRating;
  @HiveField(3)
  final int numberOfReviews;

  const PopularRestaurantReviewsResponse({
    required this.reviews,
    required this.ratingsCount,
    required this.averageRating,
    required this.numberOfReviews,
  });

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'ratingsCount': ratingsCount,
      'averageRating': averageRating,
      'numberOfReviews': numberOfReviews,
    };
  }

  factory PopularRestaurantReviewsResponse.fromJson(Map<String, dynamic> json) {
    return PopularRestaurantReviewsResponse(
      reviews: (json['reviews'] as List<dynamic>)
          .map((reviewJson) => PopularRestaurantReviewResponse.fromJson(
              reviewJson as Map<String, dynamic>))
          .toList(),
      ratingsCount: List<int>.from(json['ratingsCount']),
      averageRating: json['averageRating'].toDouble(),
      numberOfReviews: json['numberOfReviews'],
    );
  }

  PopularRestaurantReviewsResponse copyWith({
    List<PopularRestaurantReviewResponse>? reviews,
    List<int>? ratingsCount,
    double? averageRating,
    int? numberOfReviews,
  }) {
    return PopularRestaurantReviewsResponse(
      reviews: reviews ?? this.reviews,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
    );
  }

  @override
  List<Object?> get props => [
        reviews,
        ratingsCount,
        averageRating,
        numberOfReviews,
      ];
}
