import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_item_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_response.dart';

class SavedReviewsResponseModel extends SavedReviewsResponse {
  const SavedReviewsResponseModel({
    super.draftId,
    super.item,
    super.createdAt,
    super.images,
    super.videos,
  });

  factory SavedReviewsResponseModel.fromJson(Map<String, dynamic> data) =>
      SavedReviewsResponseModel(
        draftId: data['id'] as String?,
        item: data['item'] != null
            ? SavedReviewItemResponseModel.fromJson(data["item"])
            : null,
        createdAt: data["createdAt"] != null
            ? DateTime.parse(data["createdAt"])
            : null,
        images: data['draft_item_review_images'] != null
            ? data['draft_item_review_images']
                .map<DraftFileContentModel>(
                    (item) => DraftFileContentModel.fromJson(item))
                .toList()
            : [],
        videos: data['draft_item_review_videos'] != null
            ? data['draft_item_review_videos']
                .map<DraftFileContentModel>(
                    (item) => DraftFileContentModel.fromJson(item))
                .toList()
            : [],
      );
  @override
  List<Object?> get props => [];
}

class DraftFileContentModel extends DraftFileContent {
  const DraftFileContentModel({
    super.id,
    super.url,
    super.itemReviewId,
    super.createdAt,
  });
  factory DraftFileContentModel.fromJson(Map<String, dynamic> json) {
    return DraftFileContentModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      itemReviewId: json['draft_item_review_id'] ?? '',
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    );
  }

  @override
  List<Object?> get props => [];
}
