import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/models/reviewer_profile_response_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_review_response.dart';

class RestaurantReviewResponseModel extends RestaurantReviewResponse {
  RestaurantReviewResponseModel({
    required super.id,
    super.rating,
    super.comment,
    super.upVote,
    super.downVote,
    super.visibility,
    super.createdAt,
    super.updatedAt,
    super.user,
    super.images,
    super.videos,
    super.voted,
  });

  factory RestaurantReviewResponseModel.fromMap(Map<String, dynamic> data) =>
      RestaurantReviewResponseModel(
        id: data['id'] ?? "",
        rating: data['rating']?.toDouble() ?? 0.0,
        comment: data['comment'] as String? ?? "No comment on this review",
        upVote: data['upVote'] as int? ?? 0,
        downVote: data['downVote'] as int? ?? 0,
        visibility: data['visibility'] as bool? ?? false,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        user: data["user"] != null
            ? ReviewerProfileResponseModel.fromJson(data["user"])
            : ReviewerProfileResponseModel(
                id: data['user'] ?? "",
                firstName: dpLocator<AuthenticationLocalSource>()
                        .getUserCredential()
                        ?.firstName ??
                    "",
                lastName: dpLocator<AuthenticationLocalSource>()
                        .getUserCredential()
                        ?.lastName ??
                    "",
                image: data['image'] != null && data['image']['url'] != null
                    ? data['image']['url']
                    : '',
              ),
        images: (data['images'] != null && data['images'].isNotEmpty)
            ? (data['images']?.map((review) => review).toList() ?? [])
            : [],
        videos: (data['videos'] != null && data['videos'].isNotEmpty)
            ? (data['videos']?.map((review) => review["url"]).toList() ?? [])
            : [],
        voted: data['voted'] != null ? data['voted'] as int? ?? 0 : 0,
      );
}
