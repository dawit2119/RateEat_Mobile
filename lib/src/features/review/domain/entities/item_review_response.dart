import 'package:rateeat_mobile/src/features/review/domain/entities/reviewer_profile_response.dart';

class ItemReviewResponse {
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

  ItemReviewResponse({
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
}
