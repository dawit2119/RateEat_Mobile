import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

class RestaurantReviewModel extends Equatable {
  final String id;
  final double? rating;
  final String? comment;
  final int? upVote;
  final int? downVote;
  final bool? visibility;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ReviewerProfileModel? user;
  final List<dynamic>? images;
  final List<dynamic>? videos;
  final int? voted;

  const RestaurantReviewModel({
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

  factory RestaurantReviewModel.fromMap(Map<String, dynamic> data) =>
      RestaurantReviewModel(
        id: data['id'] ?? "",
        rating: data['rating'].toDouble() ?? 0.0,
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
            ? ReviewerProfileModel.fromJson(data["user"])
            : ReviewerProfileModel(
                id: data['user'],
                firstName: dpLocator<AuthenticationLocalSource>()
                    .getUserCredential()!
                    .firstName!,
                lastName: dpLocator<AuthenticationLocalSource>()
                    .getUserCredential()!
                    .lastName!,
                image: data['image'] != null && data['image']['url'] != null
                    ? data['image']['url']
                    : '',
              ),
        images: (data['images'] != null && data['images'].isNotEmpty)
            ? data['images'].map((review) => review).toList()
            : [],
        videos: (data['videos'] != null && data['videos'].isNotEmpty)
            ? data['videos'].map((review) => review["url"]).toList()
            : [],
        voted: data['voted'] != null ? data['voted'] as int? : 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'rating': rating,
        'comment': comment,
        'up_vote': upVote,
        'down_vote': downVote,
        'visibility': visibility,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'user': user?.toJson(),
        'images': images,
        'videos': videos,
        'voted': voted,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RestaurantReviewModel].
  factory RestaurantReviewModel.fromJson(String data) {
    return RestaurantReviewModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  ///
  /// Converts [RestaurantReviewModel] to a JSON string.
  String toJson() => json.encode(toMap());

  RestaurantReviewModel copyWith({
    String? id,
    double? rating,
    String? comment,
    int? upVote,
    int? downVote,
    bool? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReviewerProfileModel? user,
    List<dynamic>? images,
    List<dynamic>? videos,
    int? voted,
  }) {
    return RestaurantReviewModel(
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

  @override
  List<Object?> get props {
    return [
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
}
