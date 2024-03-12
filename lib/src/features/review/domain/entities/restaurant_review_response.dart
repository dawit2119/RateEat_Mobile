import 'package:rateeat_mobile/src/features/review/domain/entities/reviewer_profile_response.dart';

class RestaurantReviewResponse {
  String id;
  double? rating;
  String? comment;
  int? upVote;
  int? downVote;
  bool? visibility;
  DateTime? createdAt;
  DateTime? updatedAt;
  ReviewerProfileResponse? user;
  List<dynamic>? images;
  List<dynamic>? videos;
  int? voted;

  RestaurantReviewResponse({
    required this.id,
    this.rating,
    this.comment,
    this.upVote,
    this.downVote,
    this.visibility,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.images,
    this.videos,
    this.voted,
  });

  RestaurantReviewResponse copyWith({
    String? id,
    double? rating,
    String? comment,
    int? upVote,
    int? downVote,
    bool? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReviewerProfileResponse? user,
    List<dynamic>? images,
    List<dynamic>? videos,
    int? voted,
  }) {
    return RestaurantReviewResponse(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      voted: voted ?? this.voted,
    );
  }
}
