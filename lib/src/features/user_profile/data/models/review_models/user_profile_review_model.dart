import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/review_models/review_subject_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_review.dart';
import 'review_media_model.dart';

class UserReviewModel extends UserReview {
  const UserReviewModel({
    super.id,
    super.userId,
    super.rating,
    super.comment,
    super.upVote,
    super.downVote,
    super.visibility,
    super.createdAt,
    super.updatedAt,
    super.reviewSubject,
    super.images,
    super.videos,
    super.voted,
  });

  factory UserReviewModel.fromMap(Map<String, dynamic> data, isItem) =>
      UserReviewModel(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        rating: data['rating'].toDouble() ?? 0.0,
        comment: data['comment'] as String?,
        upVote: data['up_vote'] as int?,
        downVote: data['down_vote'] as int?,
        visibility: data['visibility'] as bool?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        reviewSubject: isItem
            ? ReviewSubjectModel.fromMap(
                data['item'] as Map<String, dynamic>, isItem)
            : ReviewSubjectModel.fromMap(
                data['restaurant'] as Map<String, dynamic>, isItem),
        images: isItem
            ? (data['item_review_images'] as List)
                .map((review) =>
                    ReviewMediaModel.fromMap(review as Map<String, dynamic>))
                .toList()
            : (data['restaurant_review_images'] as List)
                .map((review) =>
                    ReviewMediaModel.fromMap(review as Map<String, dynamic>))
                .toList(),
        videos: isItem
            ? (data['item_review_videos'] as List)
                .map((review) => ReviewMediaModel(url: review["url"]))
                .toList()
            : (data['restaurant_review_videos'] as List)
                .map((review) => ReviewMediaModel(url: review["url"]))
                .toList(),
        voted: data['voted'] != null ? data['voted'] as int? : 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'up_vote': upVote,
        'down_vote': downVote,
        'visibility': visibility,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'item': (reviewSubject as RestaurantModel).toMap(),
        'item_review_images':
            images.map((e) => (e as ReviewMediaModel).toMap()).toList(),
        'item_review_videos':
            videos?.map((e) => (e as ReviewMediaModel).toMap()).toList(),
      };

  UserReviewModel copyWith({
    String? id,
    String? userId,
    double? rating,
    String? comment,
    int? upVote,
    int? downVote,
    bool? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReviewSubjectModel? reviewSubject,
    List<ReviewMedia>? images,
    List<ReviewMedia>? videos,
  }) {
    return UserReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewSubject: reviewSubject ?? this.reviewSubject,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      rating,
      comment,
      upVote,
      downVote,
      visibility,
      createdAt,
      updatedAt,
      reviewSubject,
      images,
      videos,
    ];
  }
}
