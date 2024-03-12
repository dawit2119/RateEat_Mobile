import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviewer_profile_response.dart';

part 'popular_item_review_response.g.dart';

@HiveType(typeId: 39)
class PopularItemReviewResponse {
  @HiveField(0)
  String id;
  @HiveField(1)
  double? rating;
  @HiveField(2)
  String? comment;
  @HiveField(3)
  int? upVote;
  @HiveField(4)
  int? downVote;
  @HiveField(5)
  bool? visibility;
  @HiveField(6)
  DateTime? createdAt;
  @HiveField(7)
  DateTime? updatedAt;
  @HiveField(8)
  PopularItemReviewerProfileResponse? user;
  @HiveField(9)
  List<dynamic>? images;
  List<dynamic>? videos;
  @HiveField(11)
  int? voted;
  @HiveField(12)
  int? flaggedCount;

  PopularItemReviewResponse({
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
    this.flaggedCount,
  });
}
