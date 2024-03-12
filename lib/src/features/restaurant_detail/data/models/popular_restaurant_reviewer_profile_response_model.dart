// ignore_for_file: overridden_fields
// ? TODO: move the hive up to the entity layer

import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviewer_profile_response.dart';

part 'popular_restaurant_reviewer_profile_response_model.g.dart';

@HiveType(typeId: 42)
// ignore: must_be_immutable
class PopularRestaurantReviewerProfileResponseModel
    extends PopularRestaurantReviewerProfileResponse {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String firstName;
  @override
  @HiveField(2)
  final String lastName;
  @override
  @HiveField(3)
  final String image;
  @override
  @HiveField(4)
  final int? verified;
  @HiveField(5)
  final int? numberOfReviews;

  PopularRestaurantReviewerProfileResponseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.verified,
    this.numberOfReviews,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          image: image,
          verified: verified,
          numberOfReviews: numberOfReviews,
        );

  factory PopularRestaurantReviewerProfileResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PopularRestaurantReviewerProfileResponseModel(
      id: json["id"],
      firstName: json["firstName"] ?? '',
      lastName: json["lastName"] ?? '',
      image: json['image'] ?? '',
      verified: json['verified'] ?? 0,
      numberOfReviews: json['numberOfReviews'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "image": image,
      "verified": verified,
      "numberOfReviews": numberOfReviews,
    };
  }

  factory PopularRestaurantReviewerProfileResponseModel.fromMap(
      Map<String, dynamic> map) {
    return PopularRestaurantReviewerProfileResponseModel(
      id: map["id"],
      firstName: map["firstName"] ?? '',
      lastName: map["lastName"] ?? '',
      image: map['image'] ?? '',
      verified: map['verified'] ?? 0,
      numberOfReviews: map['numberOfReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "image": image,
      "verified": verified,
      "numberOfReviews": numberOfReviews,
    };
  }
}
