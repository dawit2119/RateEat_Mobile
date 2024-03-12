import 'package:rateeat_mobile/src/features/review/domain/entities/reviewer_profile_response.dart';

class ReviewerProfileResponseModel extends ReviewerProfileResponse {
  ReviewerProfileResponseModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.image,
    super.verified,
    super.numberOfReviews,
  });

  factory ReviewerProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ReviewerProfileResponseModel(
        id: json["id"],
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        image: json['image'] ?? '',
        verified: json['verified'] ?? 0,
        numberOfReviews: json["numberOfReviews"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
      };
}
