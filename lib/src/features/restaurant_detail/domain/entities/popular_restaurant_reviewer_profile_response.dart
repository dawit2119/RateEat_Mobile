import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'popular_restaurant_reviewer_profile_response.g.dart';

@HiveType(typeId: 48)
// ignore: must_be_immutable
class PopularRestaurantReviewerProfileResponse extends Equatable {
  @HiveField(0)
  String id;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String image;
  @HiveField(4)
  int? verified;
  @HiveField(5)
  int? numberOfReviews;
  PopularRestaurantReviewerProfileResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.verified,
    this.numberOfReviews,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'verified': verified,
      'numberOfReviews': numberOfReviews,
    };
  }

  factory PopularRestaurantReviewerProfileResponse.fromJson(
      Map<String, dynamic> json) {
    return PopularRestaurantReviewerProfileResponse(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      image: json['image'] as String,
      verified: json['verified'] as int?,
      numberOfReviews: json['numberOfReviews'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        image,
        verified,
        numberOfReviews,
      ];
}
