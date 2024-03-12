import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviewer_profile_response.dart';

part 'popular_restaurant_review_response.g.dart';

@HiveType(typeId: 47)
// ignore: must_be_immutable
class PopularRestaurantReviewResponse extends Equatable {
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
  PopularRestaurantReviewerProfileResponse? user;
  @HiveField(9)
  List<dynamic>? images;
  @HiveField(10)
  List<dynamic>? videos;
  @HiveField(11)
  int? voted;

  PopularRestaurantReviewResponse({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'upVote': upVote,
      'downVote': downVote,
      'visibility': visibility,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
      'images': images,
      'videos': videos,
      'voted': voted,
    };
  }

  factory PopularRestaurantReviewResponse.fromJson(Map<String, dynamic> json) {
    return PopularRestaurantReviewResponse(
      id: json['id'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      upVote: json['upVote'] as int?,
      downVote: json['downVote'] as int?,
      visibility: json['visibility'] as bool?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      user: json['user'] != null
          ? PopularRestaurantReviewerProfileResponse.fromJson(json['user'])
          : null,
      images: json['images'] as List<dynamic>?,
      videos: json['videos'] as List<dynamic>?,
      voted: json['voted'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        rating,
        comment,
        upVote,
        downVote,
        visibility,
        createdAt,
        updatedAt,
        user,
        images,
        videos,
        voted,
      ];
}
