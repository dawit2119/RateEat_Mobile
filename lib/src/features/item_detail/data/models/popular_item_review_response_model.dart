import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviewer_profile_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_review_response.dart';

class PopularItemReviewResponseModel extends PopularItemReviewResponse {
  PopularItemReviewResponseModel({
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
    super.flaggedCount,
  });

  factory PopularItemReviewResponseModel.fromJson(Map<String, dynamic> json) =>
      PopularItemReviewResponseModel(
        id: json["id"] ?? "",
        rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
        comment: json["comment"] ?? "",
        upVote: json["upVote"] ?? 0,
        downVote: json["downVote"] ?? 0,
        visibility: json['visibility'] as bool? ?? false,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        user: json["user"] != null
            ? PopularItemReviewerProfileResponseModel.fromJson(json["user"])
            : PopularItemReviewerProfileResponseModel(
                id: json['user_id'] ?? "",
                firstName: dpLocator<AuthenticationLocalSource>()
                        .getUserCredential()
                        ?.firstName ??
                    "",
                lastName: dpLocator<AuthenticationLocalSource>()
                        .getUserCredential()
                        ?.lastName ??
                    "",
                image: json['image'] != null && json['image']['url'] != null
                    ? json['image']['url']
                    : '',
              ),
        images: (json['images'] != null && json['images'].isNotEmpty)
            ? json['images'].map((review) => review).toList()
            : [],
        videos: (json['videos'] != null && json['videos'].isNotEmpty)
            ? json['videos'].map((review) => review["url"]).toList()
            : [],
        voted: json['voted'] != null ? json['voted'] as int? : 0,
        flaggedCount:
            json['flaggedCount'] != null ? json['flaggedCount'] as int? : 0,
        // You might need to change this based on the actual structure of the "videos" property.
      );
}
