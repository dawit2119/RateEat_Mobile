// ignore_for_file: overridden_fields
// ? TODO: move the hive up to the entity layer
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviewer_profile_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_review_response.dart';

part 'popular_restaurant_review_response_model.g.dart';

@HiveType(typeId: 41)
// ignore: must_be_immutable
class PopularRestaurantReviewResponseModel
    extends PopularRestaurantReviewResponse {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final double? rating;
  @override
  @HiveField(2)
  final String? comment;
  @override
  @HiveField(3)
  final int? upVote;
  @override
  @HiveField(4)
  final int? downVote;
  @override
  @HiveField(5)
  final bool? visibility;
  @override
  @HiveField(6)
  final DateTime? createdAt;
  @override
  @HiveField(7)
  final DateTime? updatedAt;
  @override
  @HiveField(8)
  final PopularRestaurantReviewerProfileResponseModel? user;
  @override
  @HiveField(9)
  final List<dynamic>? images;
  @override
  @HiveField(10)
  final List<dynamic>? videos;
  @override
  @HiveField(11)
  final int? voted;

  PopularRestaurantReviewResponseModel({
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
  }) : super(
          id: id,
          rating: rating,
          comment: comment,
          upVote: upVote,
          downVote: downVote,
          visibility: visibility,
          createdAt: createdAt,
          updatedAt: updatedAt,
          user: user,
          images: images,
          videos: videos,
          voted: voted,
        );

  factory PopularRestaurantReviewResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PopularRestaurantReviewResponseModel(
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
          ? PopularRestaurantReviewerProfileResponseModel.fromJson(json['user'])
          : null,
      images: json['images'] as List<dynamic>?,
      videos: json['videos'] as List<dynamic>?,
      voted: json['voted'] as int?,
    );
  }

  @override
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

  factory PopularRestaurantReviewResponseModel.fromMap(
      Map<String, dynamic> map) {
    return PopularRestaurantReviewResponseModel(
      id: map['id'] as String,
      rating: (map['rating'] as num?)?.toDouble(),
      comment: map['comment'] as String?,
      upVote: map['upVote'] as int?,
      downVote: map['downVote'] as int?,
      visibility: map['visibility'] as bool?,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      user: map['user'] != null
          ? PopularRestaurantReviewerProfileResponseModel.fromMap(map['user'])
          : null,
      images: map['images'] as List<dynamic>?,
      videos: map['videos'] as List<dynamic>?,
      voted: map['voted'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'upVote': upVote,
      'downVote': downVote,
      'visibility': visibility,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toMap(),
      'images': images,
      'videos': videos,
      'voted': voted,
    };
  }
}
