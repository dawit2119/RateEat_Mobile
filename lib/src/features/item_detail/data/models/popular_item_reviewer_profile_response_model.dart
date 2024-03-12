import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviewer_profile_response.dart';

class PopularItemReviewerProfileResponseModel
    extends PopularItemReviewerProfileResponse {
  PopularItemReviewerProfileResponseModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.image,
      super.verified,
      super.numberOfReviews});

  factory PopularItemReviewerProfileResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PopularItemReviewerProfileResponseModel(
          id: json["id"],
          firstName: json["firstName"] ?? '',
          lastName: json["lastName"] ?? '',
          image: json['image'] ?? '',
          verified: json['verified'] ?? 0,
          numberOfReviews: json['numberOfReviews'] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "verified": verified,
        "numberOfReviews": numberOfReviews,
      };
}
